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

    class Route
      attr_reader :app, :verbs, :pattern, :keys, :conditions, :block, :file

      # This will be called by Sinatra::Base#routes
      def initialize(app, verbs, signature)
        @app, @verbs, (@pattern, @keys, @conditions, @block) = app, [verbs].flatten, signature
      end

      # The routes signature. Should be uniq for a verb/app.
      def signature
        [pattern, keys, conditions, block]
      end

      # Whether or not a route currently is part of the routes stack.
      def active?
        verbs.all? { |verb| app.routes[verb].include? signature }
      end

      # Adds a route to the routes stack.
      def activate(at_top = false)
        verbs.each do |verb|
          next if app.routes[verb].include? signature
          invoke_hook(:route_added, verb, path, block)
          meth = at_top ? :unshift : :pop
          (routes[verb] ||= []).send(meth, signature)
        end
        self
      end

      # Removes a route from the routes stack.
      def deactivate
        verbs.each do |verb|
          next unless app.routes[verb].include? signature
          invoke_hook(:route_removed, verb, path, block)
          (routes[verb] ||= []).delete(signature)
        end
        self
      end
      
      # true if file is known
      def file?
        !!@file
      end

      # Moves a route to the top of the routes stack.
      # If the optional parameter is false, route will be moved to the bottom instead.
      def promote(at_top = true)
        deactivate.activate(at_top)
      end

      def /(path)
        pattern.to_s / path
      end

    end

    module ClassMethods
      def advanced_routes
        routes.map { |v, r| r.collect { |s| Route.new(self, v, s) }}.flatten
      end
      def get(path, opts={}, &block)
        super(path, opts={}, &block).tap { |r| r.verbs.replace ['GET', 'HEAD'] }
      end
      def route(verb, path, options={}, &block)
        path = path.pattern if path.respond_to? :pattern
        route = Route.new self, verb, super(verb, path, options, &block)
        route.file = caller_files.first.expand_path
        invoke_hook :advanced_root_added, route
        route
      end
    end

    def self.registered(klass)
      klass.extend ClassMethods
    end

  end
end