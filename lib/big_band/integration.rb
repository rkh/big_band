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
        YARD::Registry.load(Dir[files], true)
        YARD::Handlers::Sinatra::AbstractRouteHandler.routes.inject({}) do |routes, route_object|
          routes.merge route_object.http_verb => route_object.http_path
        end
      else
        raise ArgumentError, "cannot retrieve routes for #{source.inspect}"
      end
    end

  end
end