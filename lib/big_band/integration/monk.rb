require "monk"
require "big_band/integration"

module BigBand::Integration
  # In your Thorfile, place:
  #
  #   require "big_band/integration/monk"
  #   class Monk < Thor
  #     routes_task :list_routes
  #   end
  #
  # Now, running 'monk list_routes' in you project directory should
  # give you a list of all your routes.
  module Monk
    def routes_task(name = :routes)
      desc "#{routes} [FILES=#{GLOBBER.inspect}]", "lists all routes"
      define_method :routes do |files|
        BigBand::Integration.each_route(files || GLOBBER) { |v,p| say_status v, p }
      end
    end
  end
end

class Monk < Thor
  extend BigBand::Integration::Monk
end