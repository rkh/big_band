require "big_band/integration/test"
require "test/unit"

module BigBand::Integration
  # Some TestUnit example and description goes here.
  module TestUnit
    ::Test::Unit::TestCase.send :include, self
    include BigBand::Integration::Test
  end
end