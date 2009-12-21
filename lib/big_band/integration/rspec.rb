require "sinatra"
require "big_band/integration"
require "spec"
require "webrat"
require "rack/test"

module BigBand::Integration
  module RSpec
  end
  Rspec = RSpec
end

Webrat.configure { |config| config.mode = :sinatra }

Spec::Runner.configure do |conf|
  conf.include Webrat::Methods
  conf.include Rack::Test::Methods
  conf.include BigBand::Integration::RSpec
end