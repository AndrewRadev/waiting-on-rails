require 'socket'
require 'timeout'

module Support
  module Command
    def init_command_output(command)
      @pipes ||= {}

      return @pipes[command] if @pipes[command]

      Timeout.timeout(2) do
        @pipes[command] = UNIXSocket.new(pipe_path(command))
      end
    rescue Errno::ENOENT
      retry
    end

    def add_command_output(command, output)
      init_command_output(command)
      @pipes[command].write(output)
    end

    def finish_command_output(command)
      if @pipes and @pipes[command]
        @pipes[command].close
        @pipes[command] = nil
      end
    end

    private

    def pipe_path(command)
      File.expand_path(File.dirname(__FILE__) + "/../../tmp/#{command}.socket")
    end
  end
end
