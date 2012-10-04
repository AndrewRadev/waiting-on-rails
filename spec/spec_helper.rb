require 'tmpdir'
require 'simplecov'

SimpleCov.start

require 'support/matchers'
require 'support/command'
require 'support/tmp'

RSpec.configure do |config|
  config.include Support::Command
  config.include Support::Tmp

  config.around do |example|
    # Modify the PATH to add our own stubs
    original_path = ENV['PATH']
    ENV['PATH'] = "#{File.expand_path('spec/support/bin')}:#{original_path}"

    # Prepare a "tmp" directory for the tests to work with
    setup_tmp_directory

    example.call

    remove_tmp_directory
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
