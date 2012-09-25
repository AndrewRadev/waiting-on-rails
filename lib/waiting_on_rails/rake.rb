require 'pty'
require 'waiting_on_rails/player'


module WaitingOnRails
  class Rake
    def initialize(args)
      @args   = args
      @player = WaitingOnRails::Player.new
    end

    def run
      if given_tasks_are_slow?
        @player.start
        Process.wait(spawn_rake_subprocess)
      else
        exec_rake_command
      end
    ensure
      @player.stop
    end

    private

    def given_tasks_are_slow?
      @args.any? { |task| slow_tasks.include?(task) }
    end

    def slow_tasks
      [
        'routes',
      ]
    end

    def exec_rake_command
      exec 'rake', *@args
    end

    def spawn_rake_subprocess
      spawn 'rake', *@args
    end
  end
end
