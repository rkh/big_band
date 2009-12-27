require "big_band/integration/test_unit"

module BigBand::Integration
  # Some TestSpec example and description goes here.
  module TestSpec
    ::Test::Unit::TestCase.send :include, self
  end
end