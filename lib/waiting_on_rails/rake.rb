require 'waiting_on_rails/player'

module WaitingOnRails
  class Rake
    def initialize(music_player, ding_player = nil)
      @music_player = music_player
      @ding_player  = ding_player
    end

    def run(args)
      if given_tasks_are_slow?(args)
        @music_player.start(loop: true)
        Process.wait(spawn_rake_subprocess(args))
      else
        exec_rake_command(args)
      end
      @music_player.stop
      sleep 0.5
      @ding_player.start if @ding_player
    ensure
      @music_player.stop
    end

    private

    def given_tasks_are_slow?(args)
      args.any? { |task| slow_tasks.include?(task) }
    end

    def slow_tasks
      [
        'db:create',
        'db:drop',
        'db:fixtures:load',
        'db:migrate',
        'db:migrate:status',
        'db:rollback',
        'db:schema:dump',
        'db:schema:load',
        'db:seed',
        'db:setup',
        'db:structure:dump',
        'db:version',
        'routes',
        'spec',
        'spec:controllers',
        'spec:helpers',
        'spec:lib',
        'spec:mailers',
        'spec:models',
        'spec:rcov',
        'spec:requests',
        'spec:routing',
        'spec:views',
        'stats',
        'test',
        'test:recent',
        'test:uncommitted',
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
