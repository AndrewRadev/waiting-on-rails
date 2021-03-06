require 'spec_helper'
require 'waiting_on_rails/player'

module WaitingOnRails
  describe Player do
    let(:player) { Player.new('test.mp3') }

    it "spawns an external process" do
      player.start
      expect(player.pid).to be_a_running_process
    end

    it "accepts the `loop` option" do
      player.start(loop: true)
      expect(player.pid).to be_a_running_process
    end

    it "kills itself correctly" do
      player.start
      player.stop

      expect(player.pid).to_not be_a_running_process
    end
  end
end
