**Project is no longer maintained, please use [sinatra-contrib](http://www.sinatrarb.com/contrib/) instead.**

Sinatra::BigBand
================

BigBand is a stack of [Sinatra](http://sinatrarb.com) extensions, most of them developed as part of BigBand, but usable without,
each of available as a separate gem. All BigBand extensions follow the same release cycle.

Usage
-----

Simply replace `Sinatra::Base` with `Sinatra::BigBand` in your application.

    require 'sinatra/big_band'
    class MyApp < Sinatra::BigBand
      # ...
    end

The BigBand Stack
-----------------

Sinatra Extensions

* [Sinatra::AdvancedRoutes](http://github.com/rkh/sinatra-advanced-routes) – Makes routes first class objects
* [Sinatra::Compass](http://github.com/rkh/sinatra-compass) – Integrates the Compass stylesheet framework
* [Sinatra::ConfigFile](http://github.com/rkh/sinatra-config-file) – Adds YAML config file support
* [Sinatra::MoreServer](http://github.com/rkh/sinatra-more-server) – Adds support for more web servers to Sinatra::Base#run!
* [Sinatra::Namespace](http://github.com/rkh/sinatra-namespace) – Adds namespaces, allows namespaces to have local helpers.
* [Sinatra::Reloader](http://github.com/rkh/sinatra-reloader) – Advanced and fast code reloader
* [Sinatra::Sugar](http://github.com/rkh/sinatra-sugar) – Extensions for Sinatra's standard methods, like #set or #register

Sinatra tool integration:

* [AsyncRack](http://github.com/rkh/async-rack) – Makes standard rack middleware play nice with `async.callback`
* [Haml::More](http://github.com/rkh/haml-more) – Adds more functionality to Haml and Sass
* [monkey-lib](http://github.com/rkh/monkey-lib) – Thin layer over ruby extension libraries (like ActiveSupport) to make those pluggable
* [Sinatra::TestHelper](http://github.com/rkh/sinatra-test-helper) – Adds helper methods and better integration for various testing frameworks
* [Sinatra::Extension](http://github.com/rkh/sinatra-extension) – Mixin to ease Sinatra extension development.
* [Yard::Sinatra](http://github.com/rkh/yard-sinatra) – Displays Sinatra routes (including comments) in YARD output

Besides those extensions, there are others in the BigBand stack, that are external:

* [Rack Flash](http://github.com/nakajima/rack-flash) by [Pat Nakajima](http://github.com/nakajima)
* [Sinatra::DefaultCharset](http://github.com/raggi/sinatra-default_charset) by [James Tucker](http://github.com/raggi)

General Goals
-------------

* No sub-project relies on BigBand
* All sub-projects should work with MRI/REE >= 1.8.6 (including 1.9.x), JRuby >= 1.4.0 (>= 1.6.0 recommended) and Rubinius >= 1.0
* Some sub-projects should work with MagLev and IronRuby (partial MacRuby support planned for later release)
* Ease to modify the stack

Setup via gem
-------------

Try:

    gem install big_band

Running the specs / Manual setup
--------------------------------

Try something like this:

    # dependencies, rather mainstream. just in case you don't have one of those.
    gem install sinatra rspec rack-test rake
    
    # get the source
    git clone git://github.com/rkh/big_band.git
    rake setup:read_only
    
    # run the specs
    rake spec
    
    # run with multiple ruby implementations using rvm
    rvm specs ree,1.9.1,rbx,jruby
