SPEC = Gem::Specification.new do |s|

  s.name          = "big_band"
  s.version       = "0.1.0"
  s.date          = "2009-11-01"
  s.author        = "Konstantin Haase"
  s.email         = "konstantin.mailinglists@googlemail.com"
  s.homepage      = "http://github.com/rkh/big_band"
  s.platform      = Gem::Platform::RUBY
  s.summary       = "Collection of Sinatra extensions and sinatra integration for common tools like Rake, YARD and Monk." 
  s.files         = Dir.glob "{{lib,spec}/**/*,*.{rdoc,erb,gemspec},Rakefile},LICENSE"
  s.require_paths = ['lib']
  s.has_rdoc      = true
  s.rdoc_options  = %w[--all --inline-source --line-numbers --main README.rdoc --quiet
                       --tab-width 2 --title BigBand --charset UTF-8]

  s.add_dependency 'sinatra', '>= 0.9.4'
  s.add_dependency 'monkey-lib', '>= 0.1.6'
  s.add_dependency 'compass', '>= 0.8.17'
  s.add_dependency 'yard', '~> 0.2.3.5'

  s.specification_version = 2 if s.respond_to? :specification_version=
  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=

end