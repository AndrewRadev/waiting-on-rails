require 'spec_helper'
require 'waiting_on_rails/player'

# TODO (2012-09-11) Ensure process cleanup -- delete all child PIDs on exit?
module WaitingOnRails
  describe Player do
    let(:player) { Player.new }

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
