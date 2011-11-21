require 'bundler'
Bundler::GemHelper.install_tasks

require 'rspec/core'
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = FileList['spec/**/*_spec.rb']
  spec.rspec_opts = ['--backtrace']
  # spec.ruby_opts = ['-w']    
end

task :default => :spec

namespace :spec do
  desc "Runs specs on Ruby 1.8.7 and 1.9.2"
  task :rubies do
    system "rvm 1.8.7@hipchat-api_gem,1.9.2@hipchat-api_gem,1.9.3@hipchat-api_gem do rake"
  end
end