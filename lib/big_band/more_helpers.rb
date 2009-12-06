require "haml"
require "big_band/integration" # so this is usable without sinatra

class BigBand < Sinatra::Base
  
  # Adds more helper methods (coming soon).
  module MoreHelpers

    module InstanceMethods
      include Haml::Helpers

      private

      def haml_helper(&block)
        return capture_haml(&block) unless is_haml?
        yield
      end

    end

    def self.registered(klass)
      # Just in case #helpers does more magic some day.
      klass.helpers InstanceMethods
    end

  end
end