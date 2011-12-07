# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "amazon-ses-mailer/version"

Gem::Specification.new do |s|
  s.name        = "amazon-ses-mailer"
  s.version     = AmazonSes::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Eli Fox-Epstein", 'Adam Bronte']
  s.email       = ["eli@redhyphen.com", "adam@brontesaurus.com"]
  s.homepage    = ""
  s.summary     = %q{Amazon SES mailer}
  s.description = %q{Amazon SES mailer}

  s.add_dependency "ruby-hmac"
  s.add_dependency "mail"
  s.add_development_dependency "rake",    "~> 0.9.2"
  s.add_development_dependency "rspec",   "~> 2.5.0"
  s.add_development_dependency "fakeweb", "~> 1.3.0"

  s.rubyforge_project = "amazon-ses-mailer"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
