Sinatra::BigBand
================

BigBand is a stack of [Sinatra](http://sinatrarb.com) extensions, most of them developed as part of BigBand, but usable without,
each of available as a separate gem. All BigBand extensions follow the same release cycle.

Note: The list below are libraries, that already have been extracted from the BigBand master branch. More will follow.
With the release of BigBand 0.4.0 this branch will become the new master branch.

Sinatra Extensions
------------------

* [Sinatra::AdvancedRoutes](http://github.com/rkh/sinatra-advanced-routes) – Makes routes first class objects
* [Sinatra::Compass](http://github.com/rkh/sinatra-compass) – Integrates the Compass stylesheet framework
* [Sinatra::ConfigFile](http://github.com/rkh/sinatra-config-file) – Adds YAML config file support
* [Sinatra::MoreServer](http://github.com/rkh/sinatra-more-server) – Adds support for more web servers to Sinatra::Base#run!
* [Sinatra::Reloader](http://github.com/rkh/sinatra-reloader) – Advanced and fast code reloader
* [Sinatra::Sugar](http://github.com/rkh/sinatra-sugar) – Extensions for Sinatra's standard methods, like #set or #register
* [Sinatra::WebInspector](http://github.com/rkh/sinatra-web-inspector) – Allows you to inspect a running app

Sinatra Tool integration
------------------------

* [Haml::More](http://github.com/rkh/sinatra-advanced-routes) – Adds more functionality to Haml and Sass
* [monkey-lib](http://github.com/rkh/monkey-lib) – Thin layer over ruby extension libraries (like ActiveSupport) to make those pluggable
* [Sinatra::TestHelper](http://github.com/rkh/sinatra-test-helper) – Adds helper methods and better integration for various testing frameworks
* [Yard::Sinatra](http://github.com/rkh/yard-sinatra) – Displays Sinatra routes (including comments) in YARD output

Setup via gemcutter
-------------------

Try:

    gem install big_band

Note: Currently this will only install BigBand 0.3.x, since 0.4 is not out yet.

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
