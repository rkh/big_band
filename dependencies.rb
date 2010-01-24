require "depgen/depgen"

class Dependencies < Depgen
  add "compass",    :git => "git://github.com/chriseppstein/compass.git", :version => "0.8.17", :git_ref => "v%s"
  add "haml",       :git => "git://github.com/nex3/haml.git",             :version => "2.2.17", :only    => :rip
  add "monkey-lib", :git => "git://github.com/rkh/monkey-lib.git",        :version => "0.3.5",  :git_ref => "v%s"
  add "rack",       :git => "git://github.com/rack/rack.git",             :version => "1.0.1",  :only    => :rip
  add "rack-test",  :git => "git://github.com/brynary/rack-test.git",     :version => "0.5.3",  :git_ref => "v%s"
  add "rspec",      :git => "git://github.com/dchelimsky/rspec.git",      :version => "1.3.0"
  add "sinatra",    :git => "git://github.com/sinatra/sinatra.git",       :version => "0.9.4"
  add "yard",       :git => "git://github.com/lsegal/yard.git",           :version => "0.5.2"
end
