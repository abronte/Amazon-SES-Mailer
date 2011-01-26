# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "amazon-ses-mailer/version"

Gem::Specification.new do |s|
  s.name        = "amazon-ses-mailer"
  s.version     = AmazonSes::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Eli Fox-Epstein", 'abronte']
  s.email       = ["eli@redhyphen.com"]
  s.homepage    = ""
  s.summary     = %q{Amazon SES mailer}
  s.description = %q{Amazon SES mailer}

  s.rubyforge_project = "amazon-ses-mailer"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
