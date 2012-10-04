require 'socket'
require 'timeout'

module Support
  class CommandStub
    def initialize(command)
      @command = command
    end

    def init
      return if @socket

      Timeout.timeout(2) do
        @socket = UNIXSocket.new(socket_path)
      end
    rescue Errno::ENOENT
      retry
    end

    def add_output(string)
      init
      @socket.write(string)
    end

    def finish
      if @socket
        @socket.close
        @socket = nil
      end
    end

    private

    def socket_path
      File.expand_path(File.dirname(__FILE__) + "/../../tmp/#{@command}.socket")
    end
  end
end
