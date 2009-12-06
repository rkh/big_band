require "haml"
require "big_band/integration" # so this is usable without sinatra

class BigBand < Sinatra::Base
  
  # Adds more helper methods (coming soon).
  module MoreHelpers

    module InstanceMethods
      include Haml::Helpers

      private

      # Will make use of capture_haml depending on whether it is called from
      # within Haml code or not. Thus helpers may be shared between Haml and
      # others (like ERB), but still enjoy all the fancy Haml::Helpers tools.
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