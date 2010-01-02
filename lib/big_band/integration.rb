unless defined? Sinatra::Base
  module Sinatra # :nodoc:
    class Base # :nodoc:
    end
  end
end

class BigBand < Sinatra::Base
  module Integration
    GLOBBER = "{lib/**,app/**,routes/**,models/**,views/**,controllers/**,.}/*.rb"

    def self.routes_for(source)
      case source
      when Class
        source.routes
      when String
        require "big_band/advanced_routes"
        require "big_band/integration/yard"
        ::YARD::Registry.load(Dir[source], true)
        YARD::Handlers::Sinatra::AbstractRouteHandler.routes.inject({}) do |routes, r|
          (routes[r.http_verb] ||= []) << AdvancedRoutes::Route.new(r.http_verb, :path => r.http_path, :docstring => r.docstring, :file => r.file)
          routes
        end
      else
        raise ArgumentError, "cannot retrieve routes for #{source.inspect}"
      end
    end

    def self.each_route(source)
      routes_for(source).each do |verb, routes|
        routes.each do |route|
          #route.path ||= route.pattern
          yield(verb, route)
        end
      end
    end

  end
end