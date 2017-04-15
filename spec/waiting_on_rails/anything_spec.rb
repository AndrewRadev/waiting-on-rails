require 'spec_helper'
require 'waiting_on_rails/anything'

module WaitingOnRails
  describe Anything do
    let(:player)       { Player.new('test.mp3') }
    let(:runner)       { Anything.new(player) }
    let(:command_stub) { Support::CommandStub.new('command') }

    it "plays music during the entire running of the command" do
      thread = Thread.new { runner.run(['command one two three']) }

      command_stub.init

      expect(player.pid).to be_a_running_process

      command_stub.finish
      thread.join

      expect(player.pid).to_not be_a_running_process
    end
  end
end
