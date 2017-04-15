module WaitingOnRails
  class Player
    attr_reader :pid

    def initialize(music_path)
      @music_path = full_path(music_path)
    end

    def start(loop: false)
      if loop
        loop_flag = '-loop 0'
      else
        loop_flag = ''
      end

      @pid = spawn("mplayer #{loop_flag} #{@music_path}", out: '/dev/null', err: '/dev/null')
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
