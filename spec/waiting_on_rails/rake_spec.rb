require 'spec_helper'
require 'waiting_on_rails/rake'

module WaitingOnRails
  describe Rake do
    let(:player) { Player.new }
    let(:runner) { Rake.new(player) }

    before :each do
      runner.stub(:exec_rake_command)
    end

    it "just execs 'rake' if the given command is not one of the slow ones" do
      runner.should_receive(:exec_rake_command)
      runner.run(['some_fast_task'])
    end

    it "ensures the player is stopped after the command is over" do
      thread = Thread.new { runner.run(['routes']) }

      init_command_output 'rake'
      player.pid.should be_a_running_process
      finish_command_output 'rake'
      thread.join

      player.pid.should_not be_a_running_process
    end
  end
end
