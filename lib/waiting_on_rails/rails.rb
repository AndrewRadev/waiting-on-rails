require 'pty'
require 'waiting_on_rails/player'

module WaitingOnRails
  class Exit < Exception; end

  class Rails
    def initialize(music_player, ding_player = nil)
      @music_player = music_player
      @ding_player  = ding_player
    end

    def run(args)
      if not should_play_music?(args)
        exec_rails_command(args)
      end

      spawn_rails_subprocess(args) do |output, pid|
        @music_player.start
        handle_signals(pid, output)
        main_loop(output)
      end
    rescue Exit
      exit(1)
    ensure
      @music_player.stop
    end

    private

    def spawn_rails_subprocess(args)
      PTY.spawn('rails', *args) do |output, input, pid|
        yield output, pid
      end
    end

    def exec_rails_command(args)
      exec 'rails', *args
    end

    def main_loop(io)
      loop do
        begin
          line = io.readline
          puts line
          if matches_server_start?(line)
            @music_player.stop
            sleep 0.5
            @ding_player.start if @ding_player
          end
        rescue EOFError
          break
        rescue Errno::EIO
          raise Exit
        end
      end
    end

    def handle_signals(pid, output)
      %w(TERM INT).each do |signal|
        Signal.trap(signal) do
          Process.kill(signal, pid)

          loop do
            begin
              puts output.readline
            rescue EOFError
              break
            end
          end

          raise Exit
        end
      end
    end

    def should_play_music?(args)
      args.find { |arg| ['server', 's'].include? arg }
    end

    def matches_server_start?(string)
      patterns = [
        'WEBrick::HTTPServer#start', # WEBrick
        'Listening on',              # Thin, Puma
      ]

      patterns.any? { |p| string.include?(p) }
    end
  end
end
