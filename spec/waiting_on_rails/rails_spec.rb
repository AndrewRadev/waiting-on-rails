require 'spec_helper'
require 'waiting_on_rails/rails'

module WaitingOnRails
  describe Rails do
    let(:player)     { Player.new('test.mp3') }
    let(:runner)     { Rails.new(player) }
    let(:rails_stub) { Support::CommandStub.new('rails') }

    it "stops the music after seeing that the server was started" do
      thread = Thread.new { runner.run(['server']) }

      rails_stub.init
      rails_stub.add_output <<-EOF
        => Booting Puma
        => Rails 5.x.x application starting in development on http://localhost:3000
        => Run `rails server -h` for more startup options
      EOF

      expect(player.pid).to be_a_running_process

      rails_stub.add_output <<-EOF
        Puma starting in single mode...
        * Version 3.x.x (ruby 2.x.x-pxxx), codename: Something Something
        * Min threads: 5, max threads: 5
        * Environment: development
        * Listening on tcp://localhost:3000
        Use Ctrl-C to stop
      EOF
      sleep 0.5
      expect(player.pid).to_not be_a_running_process

      # The exit() call kills the test process if we don't rescue it
      begin
        rails_stub.finish
        thread.join
      rescue SystemExit
      end
    end
  end
end
