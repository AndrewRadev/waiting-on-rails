require 'waiting_on_rails/player'

module WaitingOnRails
  class Anything
    def initialize(music_player, ding_player = nil)
      @music_player = music_player
      @ding_player  = ding_player
    end

    def run(args)
      @music_player.start
      Process.wait(spawn_subprocess(args))
      @music_player.stop
      sleep 0.5
      @ding_player.start if @ding_player
    ensure
      @music_player.stop
    end

    private

    def spawn_subprocess(args)
      spawn *args
    end
  end
end
