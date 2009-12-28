require "sass"
require "big_band/integration" unless defined? BigBand # so this is usable without sinatra

class BigBand < Sinatra::Base

  # BigBand::Sass extends SassScript with more functions like min or max.
  #
  # Example:
  #   .someClass
  #     width = max(!default_width - 10px, 200px)
  #
  # This can be used without BigBand or even Sinatra.
  module Sass
    module Functions
      ::Sass::Script::Functions.send :include, self

      def min(*args)
        args.min { |a, b| a.value <=> b.value }
      end

      def max(*args)
        args.max { |a, b| a.value <=> b.value }
      end

    end
  end

end  