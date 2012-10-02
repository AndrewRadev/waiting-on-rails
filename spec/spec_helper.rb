require 'tmpdir'
require 'simplecov'

SimpleCov.start

require 'support/matchers'

RSpec.configure do |config|
  config.around do |example|
    # Modify the PATH to add our own stubs
    original_path = ENV['PATH']
    ENV['PATH'] = "#{File.expand_path('spec/support/bin')}:#{original_path}"

    # Execute each example in its own temporary directory
    Dir.mktmpdir do |dir|
      Dir.chdir(dir) do
        example.call
      end
    end

    ENV['PATH'] = original_path
  end

  config.after(:suite) do
    # Clean up all child pids
    pid  = Process.pid
    pipe = IO.popen("ps --ppid #{pid}")

    child_pids = pipe.readlines.map do |line|
      child_pid, *_ = line.split(/\s+/)
      child_pid.to_i if child_pid != ''
    end.compact

    child_pids.each { |pid| Process.kill(9, pid) }
  end
end
