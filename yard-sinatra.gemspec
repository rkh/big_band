$LOAD_PATH.unshift "lib"
require "lib/big_band/version"

YARD_SINATRA_SPEC = Gem::Specification.new do |s|

  s.name          = "yard-sinatra"
  s.version       = BigBand::VERSION
  s.date          = BigBand::DATE
  s.author        = "Konstantin Haase"
  s.email         = "konstantin.mailinglists@googlemail.com"
  s.homepage      = "http://github.com/rkh/big_band"
  s.platform      = Gem::Platform::RUBY
  s.summary       = "YARD plugin for parsing sinatra routes" 
  s.files         = ["yard-sinatra.gemspec", "lib/yard-sinatra.rb", "lib/big_band/version.rb"]
  s.require_paths = ['lib']
  s.description   = s.summary + " See README.rdoc for more infos."
  s.has_rdoc      = false

  s.add_dependency "big_band", "= #{BigBand::VERSION}"

  s.specification_version = 2 if s.respond_to? :specification_version=
  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=

end