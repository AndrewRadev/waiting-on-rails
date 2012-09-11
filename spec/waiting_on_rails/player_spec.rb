require 'spec_helper'
require 'waiting_on_rails/player'

# TODO (2012-09-11) Ensure process cleanup -- delete all child PIDs on exit?
# TODO (2012-09-11) Turn expect_ helpers into rspec matchers
module WaitingOnRails
  describe Player do
    let(:player) { Player.new }

    around :each do |example|
      example.call
    end

    def expect_pid_to_be_running(pid)
      message = "Expected pid #{pid} to be running, but wasn't"
      fail message if pid.nil?

      begin
        Process.getpgid(pid)
      rescue Errno::ESRCH
        fail message
      end
    end

    def expect_pid_to_not_be_running(pid)
      begin
        puts Process.getpgid(pid)
        fail "Expected pid #{pid} to not be a running process"
      rescue Errno::ESRCH
      end
    end

    it "spawns an external process" do
      player.start

      expect_pid_to_be_running(player.pid)

      Process.kill(9, player.pid)
    end

    it "kills itself correctly" do
      player.start
      player.stop

      expect_pid_to_not_be_running(player.pid)
    end
  end
end
