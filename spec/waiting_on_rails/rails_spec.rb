require 'spec_helper'
require 'waiting_on_rails/rails'

module WaitingOnRails
  describe Rails do
    let(:player)     { Player.new('test.mp3') }
    let(:runner)     { Rails.new(player) }
    let(:rails_stub) { Support::CommandStub.new('rails') }

    it "stops the music after seeing that the server was started" do
      runner.stub(:should_play_music? => true)

      thread = Thread.new { runner.run(['server']) }

      rails_stub.init
      rails_stub.add_output <<-EOF
        => Booting WEBrick
        => Rails 3.0.x application starting in development on http://0.0.0.0:3000
        => Call with -d to detach
        => Ctrl-C to shutdown server
      EOF

      player.pid.should be_a_running_process

      rails_stub.add_output <<-EOF
        [2012-10-04 18:48:21] INFO  WEBrick 1.3.1
        [2012-10-04 18:48:21] INFO  ruby 1.9.3 (2012-04-20) [x86_64-linux]
        [2012-10-04 18:48:21] INFO  WEBrick::HTTPServer#start: pid=18105 port=3000
      EOF
      sleep 0.5
      player.pid.should_not be_a_running_process

      # TODO (2012-10-04) Not very nice what with the SystemExit. Figure out a way to refactor.
      begin
        rails_stub.finish
        thread.join
      rescue SystemExit
      end
    end
  end
end
