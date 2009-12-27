require "monk"
require "big_band/integration"

module BigBand::Integration
  # Some Monk example and description goes here.
  module Monk
    def routes_task(name = :routes)
      desc "routes [FILES=#{GLOBBER.inspect}]", "lists all routes"
      define_method :routes do |files|
        BigBand::Integration.routes_for(files || GLOBBER).each { |v, p| say_status v, p }
      end
    end
  end
end

class Monk < Thor
  extend BigBand::Integration::Monk
end