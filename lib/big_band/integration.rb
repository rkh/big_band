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
        require "big_band/integration/yard"
        ::YARD::Registry.load(Dir[source], true)
        YARD::Handlers::Sinatra::AbstractRouteHandler.routes.inject({}) do |routes, route_object|
          routes[route_object.http_verb] ||= []
          routes[route_object.http_verb] << route_object.http_path
          routes
        end
      else
        raise ArgumentError, "cannot retrieve routes for #{source.inspect}"
      end
    end

    def self.each_route(source)
      routes_for(source).each do |verb, routes|
        routes.each do |route|
          path   = route.path    if route.respond_to? :path
          path ||= route.pattern if route.respond_to? :pattern
          path ||= route[0]      if route.is_a? Array
          path ||= route
          yield(verb, path)
        end
      end
    end

  end
end