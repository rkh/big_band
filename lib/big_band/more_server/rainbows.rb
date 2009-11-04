require "big_band/more_server/unicorn"
require "rainbows"

class BigBand < Sinatra::Base
  module MoreServer
    # Rack Handler to use Rainbows for Sinatra::Base.run!
    module Rainbows
      def self.run(app, options = {})
        BigBand::MoreServer::Unicorn.run app, options.merge(:Backend => ::Rainbows)
      end
    end
  end
end