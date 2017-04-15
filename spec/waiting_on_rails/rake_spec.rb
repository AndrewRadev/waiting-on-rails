require 'spec_helper'
require 'waiting_on_rails/rake'

module WaitingOnRails
  describe Rake do
    let(:player)    { Player.new('test.mp3') }
    let(:runner)    { Rake.new(player) }
    let(:rake_stub) { Support::CommandStub.new('rake') }

    before :each do
      allow(runner).to receive(:exec_rake_command)
    end

    it "just execs 'rake' if the given command is not one of the slow ones" do
      expect(runner).to receive(:exec_rake_command)
      runner.run(['some_fast_task'])
    end

    it "plays music during the entire running of the command" do
      thread = Thread.new { runner.run(['routes']) }

      rake_stub.init

      expect(player.pid).to be_a_running_process

      rake_stub.finish
      thread.join

      expect(player.pid).to_not be_a_running_process
    end
  end
end
