require "big_band/integration"
require "spec"
require "webrat"
require "rack/test"

Webrat.configure { |config| config.mode = :sinatra }

module BigBand::TestMethods
end

Spec::Runner.configure do |conf|
  conf.include Webrat::Methods
  conf.include Rack::Test::Methods
  conf.include BigBand::TestMethods
end