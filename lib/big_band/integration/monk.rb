require "monk"
require "big_band/integration"

class Monk < Thor
  
  desc "routes [FILES=#{GLOBBER.inspect}]", "lists all routes"
  def routes(files = GLOBBER)
    BigBand::Integration.routes_for(files).each do |verb, path|
      say_status verb, path
    end
  end 

end