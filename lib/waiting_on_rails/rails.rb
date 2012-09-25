require 'pty'
require 'waiting_on_rails/player'

module WaitingOnRails
  class Exit < Exception; end

  class Rails
    def initialize(args)
      @args   = args
      @player = WaitingOnRails::Player.new
    end

    def run
      if not should_play_music?(@args)
        exec_rails_command
      end

      spawn_rails_subprocess do |output, pid|
        @player.start
        handle_signals(pid, output)
        main_loop(output)
      end
    rescue Exit
      exit(1)
    ensure
      @player.stop
    end

    private

    def spawn_rails_subprocess
      PTY.spawn('rails', *@args) do |output, input, pid|
        yield output, pid
      end
    end

    def exec_rails_command
      exec 'rails', *@args
    end

    def main_loop(io)
      loop do
        begin
          line = io.readline
          puts line
          @player.stop if matches_server_start?(line)
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
      File.exists?('script/rails') and args.find { |arg| ['server', 's'].include? arg }
    end

    def matches_server_start?(string)
      patterns = [
        'WEBrick::HTTPServer#start', # WEBrick
        'Listening on',              # Thin
      ]

      patterns.any? { |p| string.include?(p) }
    end
  end
end
