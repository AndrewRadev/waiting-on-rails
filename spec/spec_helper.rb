require 'tmpdir'
require 'simplecov'

SimpleCov.start

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
end
