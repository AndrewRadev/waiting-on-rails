require 'waiting_on_rails/player'

module WaitingOnRails
  class Rake
    def initialize(player = nil)
      @player = player || WaitingOnRails::Player.new
    end

    def run(args)
      if given_tasks_are_slow?(args)
        @player.start
        Process.wait(spawn_rake_subprocess(args))
      else
        exec_rake_command(args)
      end
    ensure
      @player.stop
    end

    private

    def given_tasks_are_slow?(args)
      args.any? { |task| slow_tasks.include?(task) }
    end

    def slow_tasks
      [
        'routes',
      ]
    end

    def exec_rake_command(args)
      exec 'rake', *args
    end

    def spawn_rake_subprocess(args)
      spawn 'rake', *args
    end
  end
end
