require 'spec_helper'
require 'waiting_on_rails/player'

module WaitingOnRails
  describe Player do
    let(:player) { Player.new('test.mp3') }

    around :each do |example|
      example.call
    end

    it "spawns an external process" do
      player.start
      player.pid.should be_a_running_process
    end

    it "kills itself correctly" do
      player.start
      player.stop

      player.pid.should_not be_a_running_process
    end
  end
end
