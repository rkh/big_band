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

    class RouteCollection

      instance_methods.each { |meth| undef_method(meth) unless meth.to_s =~ /^(__|object_id$)/ }
      attr_reader :routes

      def initialize(*routes)
        @routes = []
        push routes.flatten
      end

      def push(*routes)
        routes.flatten.each do |route|
          raise ArgumentError, "routes for one group may only differ in verb" if signature and signature != route
          routes << route
        end
        self
      end
      alias << push

      def signature
        routes.first
      end

      def method_missing(name, args, &block)
        results = routes.map { |r| r.send(name, args, &block) }
        return results.all? { |e| e } if name.to_s =~ /\?$/
        results
      end

    end

    module Route

      attr_accessor :app, :verb, :file, :line

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
        app.routes[verb].include? signature
      end

      def activate(at_top = false)
        return if active?
        invoke_hook :route_added, verb, path, block
        invoke_hook :advanced_root_activated, self
        meth = at_top ? :unshift : :pop
        (app.routes[verb] ||= []).send(meth, self)
        self
      end

      def deactivate
        return unless active?
        invoke_hook :route_removed, verb, path, block
        invoke_hook :deadvanced_root_activated, self
        (app.routes[verb] ||= []).delete(signature)
        self
      end
      
      def promote
        deavtivate
        activate(true)
      end

      def file?
        !!@file
      end
      
      def inspect
        "#<BigBand::AdvancedRoutes::Route #{ivar_inspect.join ", "}>"
      end
      
      private
      
      def ivar_inspect
        [:signature, :verb, :app, :file, :line].map do |var|
          value = send(var)
          "@#{var}=#{value.inspect}" unless value.nil?
        end.compact
      end

    end

    module ClassMethods

      def get(path, opts={}, &block)
        route = super(path, opts={}, &block)
        RouteCollection.new route.to_route!("GET"), route.to_route("HEAD")
      end

      def route(verb, path, options={}, &block)
        file, line = block.source_location if block.respond_to? :source_location
        file ||= caller_files.first
        route = super(verb, path, options, &block)
        route.to_route! verb, :app => self, :file => file.expand_path, :line => line
        invoke_hook :advanced_root_added, route
        route
      end
      
      def each_route(&block)
        return enum_for(:each_route) if respond_to? :enum_for and not block
        routes.inject([]) { |result, (verb, list)| result.push *list.each(&block) }
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