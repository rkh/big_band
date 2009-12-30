require "sinatra/base"
require "monkey-lib"

class BigBand < Sinatra::Base

  # This extension intends to ease setting up your stack. For instance, BigBand relies on methods from
  # an extension library (like AcitveSupport). However, instead of imposing such a library on you, it plays
  # well with all common extension libraries (like AcitveSupport, Extlib, Backports or Facets). Usually
  # BigBand will decide which library to use (if one of those has already been loaded, it will be used).
  # However, you might want to tell BigBand which library to use. +use(:active_support)+ has the advantage
  # (compared to +require("active_support")+), that it will only load the parts of ActiveSupport BigBand
  # relies on, instead of loading all parts of it – see below on how to influence this behavior.
  #
  # Example:
  #
  #   class MyApp < BigBand
  #     use :core_ext   => :active_support, :orm     => :datamapper,
  #         :middleware => Rack::Reloader,  :testing => [:rspec, :webrat]
  #   end
  #
  # How you write the DSL really does not matter that much:
  #
  #   use :sequel               # Here, BigBand will try to figure out what kind of library Sequel is.
  #   use :orm, :sequel         # In this case, BigBand will try to use Sequel as ORM and configure it.
  #   use :orm => :sequel       # This syntax is handy for setting up multiple libraries in one line.
  #   use_orm :sequel           # This syntax is somewhat compatible with Merb.
  #   use.orm :sequel           # This is a side-product of the block style syntax below.
  #   use { orm :sequel }       # I like this syntax for setting up multiple libraries (very stacky).
  #   use { |u| u.orm :sequel } # Like the one above, but without abusing instance_eval (thus not changing self)
  #
  # Note that ultimately all but middleware map to +use_*+. Middleware gets handled directly inside +use+, since it
  # is the inherited behavior.
  #
  # But wait, didn't I just abuse +Sinatra::Base#use+? Yep, but that's ok. Passing something different than a Symbol
  # or a Hash as first argument will trigger the normal behavior (i.e. setup a Rack middleware).
  #
  # Also note that, per default, testing libraries will only be set up when running in test environment.
  module StackHelper

    class UseProxy
      attr_accessor :app
      def initialize(app)
        @app = app
      end
      def method_missing(name, *args, &block)
        app.send(:use, name.to_sym, *args, &block)
      end
    end

    def use(lib = nil, *args, &block)
      case lib
      when :middleware
        middleware, *params = args
        middleware = BigBand::StackHelper.middleware_for(middleware) if middleware.is_a? Symbol
        super(middleware, *params, &block)
      when :orm, :core_ext, :test, :testing then send("use_#{lib}", *args, &block)
      when Symbol then use(BigBand::StackHelper.type_for(lib), lib, *args, &block)
      when Hash then lib.each { |k,v| use(k, v, *args, &block) }
      when Array then lib.each { |l| use(l, *args, &block) }
      when nil
        @use_proxy ||= UseProxy.new self
        @use_proxy.instance_yield(&block) if block
        @use_proxy
      else super
      end
    end

    def use_core_ext(lib, options = {})
      warn("currently ignoring options for #{__method__}") unless options.empty?
      Monkey.backend = lib
    end

    def use_orm(lib, options = {})
      raise NotImplementedError
    end

    def use_middleware(middleware, *args, &block)
      use(:middleware, middleware, *args, &block)
    end

    def use_testing(lib, options = {})
      raise NotImplementedError
    end

    alias use_test use_testing

  end
end