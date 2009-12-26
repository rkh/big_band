require "big_band/integration/test"
require "spec"

module BigBand::Integration
  module RSpec
    include BigBand::Integration::Test
    ::Spec::Runner.configure { |c| c.include self }
  end
  Rspec = RSpec
end