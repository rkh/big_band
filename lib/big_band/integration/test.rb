require "sinatra"
Sinatra::Base.set :environment, :test

require "big_band"
require "big_band/integration"

require "rack/test"
#require "webrat"
#Webrat.configure { |config| config.mode = :sinatra }

module BigBand::Integration
  module Test

    #include Webrat::Methods
    include Rack::Test::Methods

    attr_writer :app
    def app(*options, &block)
      unless block.nil? and options.empty?
        superclass   = options.first if options.size == 1 and options.first.is_a? Class
        superclass ||= BigBand(*options)
        @app         = Class.new(superclass, &block)
        inspection   = "app"
        inspection << "(" << options.map { |o| o.inspect }.join(", ") << ")" unless options.empty?
        inspection << " { ... }" if block
        @app.class_eval "def self.inspect; #{inspection.inspect}; end"
      end
      @app || BigBand.applications.last || Sinatra::Application
    end

    def define_route(verb, *args, &block)
      app.send(verb, *args, &block)
    end

    def browse_route(verb, *args, &block)
      send(verb, *args, &block)
      last_response
    end

  end
end