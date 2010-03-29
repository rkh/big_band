TODO
====

For 0.4.0 release
-----------------

All subprojects:

* Add licenses, deps.rip, maybe dependencies file for monk

BigBand:

* Create some sort of website (GitHub Pages?)
* More documentation
* Write example app

haml-more:

* specs

monkey-lib:

* Change README format to Markdown

sinatra-config-file:

* Write some specs

sinatra-test-helper:

* maybe add gemspecs for sinatra-rspec and such (not sure about that one)

sinatra-web-inspector:

* check dependency stuff, add some css

Extensions to be extracted:

* Integration for Rake and Monk/Thor
* Compass framework big\_band

After 0.4.0
-----------

Most that stuff can of course, make it to 0.4.0.

General:

* Implement more fancy stuff
* Padrino integration (maybe an example app, maybe some docs, dunno)
* Monk skeleton using big\_band
* See if stack\_helper can be extracted and is of any use (stack\_helper branch)
* Improve inline documentation (YARD tags)

sinatra-advanced-routes:

* Make compatible with [Usher](http://github.com/joshbuddy/usher)
* Make compatible with [padrino-core/routing](http://github.com/padrino/padrino-framework/issues/issue/46)

Subprojects to be published or written:

* queueba (yet another message queue based on redis)
* sinatra-postpone
* "sinatra-queueba" or redis channel for pusher + pusher integration for sinatra

Before 0.5.0
------------

BigBand:

* remove `::BigBand`

monkey-lib:

* remove `Object#metaclass`
* remove `Object#metaclass_eval`

