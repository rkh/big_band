$LOAD_PATH.unshift '.'
require 'subproject'

SPEC = Gem::Specification.new do |s|
  # Get the facts.
  s.name             = "big_band"
  s.version          = "0.4.0"
  s.description      = "Making Sinatra swing."

  # BigBand depedencies
  Subproject.each { |p| s.add_dependency p.name, "~> #{s.version}" }
  s.add_dependency 'rack-flash', '>= 0.1.1'
  s.add_dependency 'sinatra-default_charset', '>= 0.2.0'

  # External dependencies
  s.add_development_dependency "rspec", ">= 1.3.0"

  # Those should be about the same in any BigBand extension.
  s.authors          = ["Konstantin Haase"]
  s.email            = "konstantin.mailinglists@googlemail.com"
  s.files            = Dir["{{lib,spec,tasks}/**/*,*.{rb,md},Rakefile,LICENSE}"]
  s.has_rdoc         = 'yard'
  s.homepage         = "http://github.com/rkh/#{s.name}"
  s.require_paths    = ["lib"]
  s.summary          = s.description
end
