require "big_band/integration/test_unit"

module BigBand::Integration
  module TestSpec
    ::Test::Unit::TestCase.send :include, self
  end
end