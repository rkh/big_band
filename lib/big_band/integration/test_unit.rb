require "big_band/integration/test"
require "test/unit"

module BigBand::Integration
  module TestUnit
    ::Test::Unit::TestCase.send :include, self
    include BigBand::Integration::Test
  end
end