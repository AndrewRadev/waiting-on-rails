module WaitingOnRails
  class Player
    def initialize
      @pid = nil
    end

    def start
      @pid = spawn("mplayer #{music_path}", :out => '/dev/null', :err => '/dev/null')
    end

    def stop
      Process.kill('TERM', @pid)
      Process.wait
      true
    rescue Errno::ESRCH
      false
    end

    private

    def music_path
      File.expand_path("#{File.dirname(__FILE__)}/../../vendor/elevator.mp3")
    end
  end
end
