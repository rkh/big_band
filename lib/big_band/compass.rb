require "sinatra/base"
require "big_band/basic_extensions"
require "big_band/advanced_routes"
require "big_band/compass/big_band"

class BigBand < Sinatra::Base
  
  # Integrates the Compass stylesheet framework with Sinatra.
  #
  # Usage without doing something:
  #
  #   require "big_band"
  #   class Foo < BigBand; end
  #
  # If you create a directory called views/stylesheets and place your
  # sass files in there, there you go. Just call stylesheet(name) form
  # your view to get the correct stylesheet tag. The URL for your
  # stylesheets will be /stylesheets/:name.css.
  #
  # Of course you can use any other setup. Say, you want to store your
  # stylesheets in views/css and want the URL to be /css/:name.css:
  #
  #   class Foo < BigBand
  #     get_compass("css")
  #   end
  #
  # But what about more complex setups?
  #
  #   class Foo < BigBand
  #     set :compass, :sass_dir => "/foo/bar/blah"
  #     get_compass("/foo/:name.css") do
  #       compass :one_stylesheet
  #     end
  #   end
  #
  # Note that already generated routes will be deactivated by calling
  # get_compass again.
  module Compass

    module ClassMethods
      attr_reader :compass_route
      def get_compass(path, &block)
        if path
          block ||= Proc.new do |file|
            response['Cache-Control'] = 'public' if self.class.production?
            compass block.call(params[:name]).to_sym
          end
          set :compass, :sass_dir => klass.views.join(path) unless compass[:sass_dir] && compass[:sass_dir].directory?
        end
        @compass_route.deactivate if @compass_route
        @compass_route = get(path / ":name.css", &block)
      end
    end
    
    module InstanceMethods
      def compass(file, options = {})
        options.merge! Compass.sass_engine_options
        sass file, options
      end
      def stylesheet(*args)
        raise NotImplementedError, "yet to be implemented"
      end
    end
    
    def self.registered(klass)
      klass.register BasicExtensions
      klass.register AdvancedRoutes
      klass.extend ClassMethods
      klass.send :include, InstanceMethod
      klass.set :compass, :root_path => klass.root_path, :output_style => :compact,
                          :sass_dir => klass.views.join("stylesheets")
      set_app_file(klass) if klass.app_file?
    end
    
    def self.set_app_file(klass)
      klass.set :compass, :root_path => klass.root_path
      get_compass("stylesheets") if klass.views.join("stylesheets").directory?
    end
    
    def self.set_compass(options = {})
      Compass.configuration do |config|
        options.each do |option, value|
          config.send "#{option}=", value
        end
      end
    end
    
  end
end