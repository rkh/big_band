require "sinatra/base"

class BigBand < Sinatra::Base
  # Adds more servers to Sinatra::Base#run! (currently unicorn and rainbows).
  module MoreServer
    autoload :Unicorn,  "big_band/more_server/unicorn"
    autoload :Rainbows, "big_band/more_server/rainbows"
    def self.registered(klass)
      Rack::Handler.register "unicorn", "BigBand::MoreServer::Unicorn"
      Rack::Handler.register "rainbows", "BigBand::MoreServer::Rainbows"
      klass.server.unshift "rainbows", "unicorn"
    end
  end
end