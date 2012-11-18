module WaitingOnRails
  class Player
    attr_reader :pid

    def initialize(music_path)
      @music_path = full_path(music_path)
    end

    def start
      @pid = spawn("mplayer #{@music_path}", :out => '/dev/null', :err => '/dev/null')
    end

    def stop
      return true if @pid.nil?
      Process.kill(15, @pid)
      Process.wait(@pid)
      true
    rescue Errno::ESRCH, Errno::ECHILD
      false
    end

    private

    def full_path(path)
      File.expand_path("#{File.dirname(__FILE__)}/../../vendor/#{path}")
    end
  end
end
