$LOAD_PATH.unshift "lib"
require "lib/big_band/version"

SPEC = Gem::Specification.new do |s|

  s.name          = "big_band"
  s.version       = BigBand::VERSION
  s.date          = BigBand::DATE
  s.author        = "Konstantin Haase"
  s.email         = "konstantin.mailinglists@googlemail.com"
  s.homepage      = "http://github.com/rkh/big_band"
  s.platform      = Gem::Platform::RUBY
  s.summary       = "Collection of Sinatra extensions and sinatra integration for common tools like Rake, YARD and Monk." 
  s.files         = Dir.glob("**/*").reject { |f| File.basename(f)[0] == ?. }
  s.require_paths = ['lib']
  s.has_rdoc      = true
  s.description   = s.summary + " See README.rdoc for more infos."
  s.rdoc_options  = %w[-a -S -N -m README.rdoc -q -w 2 -t BigBand -c UTF-8]

  s.add_dependency 'sinatra',    '>= 0.9.4'
  s.add_dependency 'monkey-lib', '>= 0.3.2'
  s.add_dependency 'compass',    '>= 0.8.17'
  s.add_dependency 'yard',       '>= 0.5.2'
  s.add_dependency 'rack-test',  '>= 0.5.3'

  s.specification_version = 2 if s.respond_to? :specification_version=
  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=

end