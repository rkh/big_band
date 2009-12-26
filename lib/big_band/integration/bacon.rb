require "big_band/integration/test"
require "bacon"

module BigBand::Integration
  module TestUnit
    ::Bacon::Context.send :include, self
    include BigBand::Integration::Test
  end
end