require "big_band/integration/test"
require "bacon"

module BigBand::Integration
  # Some Bacon example and description goes here.
  module Bacon
    ::Bacon::Context.send :include, self
    include BigBand::Integration::Test
  end
end