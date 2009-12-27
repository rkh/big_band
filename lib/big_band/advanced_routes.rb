require "sinatra/base"

class BigBand < Sinatra::Base

  # AdvancedRoutes makes routes first class objects in Sinatra:
  #
  #   require "sinatra"
  #   require "big_band"
  #
  #   admin_route = get "/admin" do
  #     administrate_stuff
  #   end
  #
  #   before do
  #     # Let's deactivate the route if we have no password file.
  #     if File.exists? "admin_password"
  #       admin_route.activate
  #     else
  #       admin_route.deactivate 
  #     end
  #   end
  #
  #   first_route = get "/:name" do
  #     # stuff
  #   end
  #
  #   other_route = get "/foo_:name" do
  #     # other stuff
  #   end
  #
  #   # Unfortunatly first_route will catch all the requests other_route would
  #   # have gotten, since it has been defined first. But wait, we can fix this!
  #   other_route.promote
  module AdvancedRoutes

    module ArrayMethods
      ::Array.send :include, self

      def to_route(verb, args = {})
        dup.to_route! verb, args
      end

      def to_route!(verb, args = {})
        extend BigBand::AdvancedRoutes::Route
        self.verb = verb
        args.each do |key, value|
          send "#{key}=", value
        end
        self
      end

      def signature
        self
      end

    end

    module Route

      attr_accessor :app, :verb, :file, :line, :path

      def pattern;    self[0]; end
      def keys;       self[1]; end
      def conditions; self[2]; end
      def block;      self[3]; end
      alias to_proc block

      def pattern=(value);    self[0] = value; end
      def keys=(value);       self[1] = value; end
      def conditions=(value); self[2] = value; end
      def block=(value);      self[3] = value; end

      def signature
        [pattern, keys, conditions, block]
      end

      def active?
        app.routes[verb].include? self
      end

      def activate(at_top = false)
        also_change.each { |r| r.activate }
        return if active?
        meth = at_top ? :unshift : :push
        (app.routes[verb] ||= []).send(meth, self)
        invoke_hook :route_added, verb, path, block
        invoke_hook :advanced_root_activated, self
        self
      end

      def deactivate
        also_change.each { |r| r.deactivate }
        return unless active?
        (app.routes[verb] ||= []).delete(signature)
        invoke_hook :route_removed, verb, path, block
        invoke_hook :advanced_root_deactivated, self
        self
      end

      def promote(upwards = true)
        also_change.each { |r| r.promote(upwards) }
        deactivate
        activate(upwards)
      end

      def file?
        !!@file
      end

      def inspect
        "#<BigBand::AdvancedRoutes::Route #{ivar_inspect.join ", "}>"
      end

      def to_route(verb, args = {})
        args = args.dup
        [:app, :verb, :file, :line, :path].each { |key| args[key] ||= send(key) }
        super(verb, args)
      end

      def also_change(*other_routes)
        (@also_change ||= []).push(*other_routes)
      end

      private

      def ivar_inspect
        [:signature, :verb, :app, :file, :line].map do |var|
          value = send(var)
          "@#{var}=#{value.inspect}" unless value.nil?
        end.compact
      end

      def invoke_hook(*args)
        app.send(:invoke_hook, *args)
      end

    end

    module ClassMethods

      def get(path, opts={}, &block)
        first_route, *other_routes = capture_routes { super }
        first_route.also_change(*other_routes)
        first_route
      end

      def route(verb, path, options={}, &block)
        file, line = block.source_location if block.respond_to? :source_location
        file ||= caller_files.first
        route = super(verb, path, options, &block)
        route.to_route! verb, :app => self, :file => file.expand_path, :line => line, :path => path
        invoke_hook :advanced_root_added, route
        @capture_routes << route if @capture_routes
        route
      end

      def each_route(&block)
        return enum_for(:each_route) if respond_to? :enum_for and not block
        routes.inject([]) { |result, (verb, list)| result.push *list.each(&block) }
      end

      private

      def capture_routes
        capture_routes_was, @capture_routes = @capture_routes, []
        yield
        captured, @capture_routes = @capture_routes, capture_routes_was
        captured
      end

    end

    def self.registered(klass)
      klass.extend ClassMethods
      klass.routes.each do |verb, routes|
        routes.each do |route|
          route.to_route! verb, :app => klass
          klass.send :invoke_hook, :advanced_root_added, route
        end
      end
    end

  end
end