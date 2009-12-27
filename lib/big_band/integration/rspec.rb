require "big_band/integration/test"
require "spec"

module BigBand::Integration
  # Some RSpec example and description goes here.
  module RSpec
    include BigBand::Integration::Test
    ::Spec::Runner.configure { |c| c.include self }
  end
  Rspec = RSpec
end