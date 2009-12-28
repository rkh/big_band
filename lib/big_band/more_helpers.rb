require "haml"
require "big_band/integration" unless defined? BigBand # so this is usable without sinatra

class BigBand < Sinatra::Base

  # Adds more helper methods (more docs coming soon).
  module MoreHelpers

    module InstanceMethods
      include Haml::Helpers

      def content_for(name, &block)
        name = name.to_s
        @content_for ||= Hash.new {|h,k| h[k] = [] }
        @content_for[name] << block if block
        @content_for[name]
      end

      def yield_content(name, *args)
        haml_helper do
          content_for(name).each do |block|
            result = block.call(*args)
            haml_concat result unless block_is_haml? block
          end
        end
      end

      def get_content(name, *args)
        non_haml { yield_content(name, *args) }
      end

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