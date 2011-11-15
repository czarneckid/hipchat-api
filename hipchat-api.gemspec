# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

require 'hipchat-api'

Gem::Specification.new do |s|
  s.name        = "hipchat-api"
  s.version     = HipChat::API::VERSION
  s.authors     = ["David Czarnecki"]
  s.email       = ["czarneckid@acm.org"]
  s.homepage    = "http://github.com/czarneckid/hipchat-api"
  s.summary     = %q{Ruby gem for interacting with HipChat}
  s.description = %q{Ruby gem for interacting with HipChat}

  s.rubyforge_project = "hipchat-api"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency('httparty')
  
  s.add_development_dependency('fakeweb')
  s.add_development_dependency('mocha')
  s.add_development_dependency('rspec')
end


