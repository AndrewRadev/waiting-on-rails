module WaitingOnRails
  class Player
    attr_reader :pid

    def initialize
    end

    def start
      @pid = spawn("mplayer #{music_path}", :out => '/dev/null', :err => '/dev/null')
      Process.detach(@pid)
    end

    def stop
      raise "Player was not started." if @pid.nil?
      Process.kill('TERM', @pid)
      Process.wait
      true
    rescue Errno::ESRCH, Errno::ECHILD
      false
    end

    private

    def music_path
      File.expand_path("#{File.dirname(__FILE__)}/../../vendor/elevator.mp3")
    end
  end
end
