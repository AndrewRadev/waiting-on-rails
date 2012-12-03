require File.expand_path('../lib/waiting_on_rails/version', __FILE__)

Gem::Specification.new do |s|
  s.name        = 'waiting_on_rails'
  s.version     = WaitingOnRails::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Andrew Radev', 'Joan Karadimov']
  s.email       = ['andrey.radev@gmail.com']
  s.homepage    = 'http://github.com/AndrewRadev/waiting_on_rails'
  s.summary     = 'Plays elevator music until `rails server` boots'
  s.description = <<-D
    Bored of waiting on "rails server"? No more! This gem plays some nice
    elevator music when you run `waiting-on-rails server` and stops it when the
    server is ready.
  D

  s.add_development_dependency 'rspec', '>= 2.0.0'
  s.add_development_dependency 'rake'

  s.required_rubygems_version = '>= 1.3.6'
  s.rubyforge_project         = 'waiting_on_rails'

  s.files        = Dir['{lib}/**/*.rb', 'bin/*', 'vendor/*', 'LICENSE', '*.md']
  s.require_path = 'lib'
  s.executables  = ['waiting-on-rails', 'waiting-on-rake']
end
