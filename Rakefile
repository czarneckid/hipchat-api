# encoding: utf-8

require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "hipchat-api"
  gem.homepage = "http://github.com/czarneckid/hipchat-api"
  gem.license = "MIT"
  gem.summary = %Q{Ruby gem for interacting with HipChat}
  gem.description = %Q{Ruby gem for interacting with HipChat}
  gem.email = "czarneckid@acm.org"
  gem.authors = ["David Czarnecki"]
  # dependencies defined in Gemfile
end
Jeweler::RubygemsDotOrgTasks.new

require 'rspec/core'
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = FileList['spec/**/*_spec.rb']
  spec.rspec_opts = ['--backtrace']
  # spec.ruby_opts = ['-w']    
end

RSpec::Core::RakeTask.new(:rcov) do |spec|
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rcov = true
end

task :default => :spec

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "hipchat-api #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

namespace :spec do
  desc "Runs specs on Ruby 1.8.7 and 1.9.2"
  task :rubies do
    system "rvm 1.8.7@hipchat-api_gem,1.9.2@hipchat-api_gem rake"
  end
end