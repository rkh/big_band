require "sinatra/base"
require "unicorn"
require "rack/content_length"
require "rack/chunked"

class BigBand < Sinatra::Base
  module MoreServer
    # Rack Handler to use Unicorn for Sinatra::Base.run!
    module Unicorn
      def self.run(app, options={})
        app = Rack::Builder.new do
          # TODO: env dependend stuff.
          use Rack::CommonLogger, $stderr
          use Rack::ShowExceptions
          use Rack::Lint
          run app
        end.to_app
        options[:Backend] ||= ::Unicorn
        options[:Host] ||= ::Unicorn::Const::DEFAULT_HOST
        options[:Port] ||= ::Unicorn::Const::DEFAULT_PORT
        options[:listeners] = ["#{options.delete :Host}:#{options.delete :Port}"]
        server = options.delete(:Backend)::HttpServer.new app, options
        yield server if block_given?
        server.start.join
      end
    end
  end
end