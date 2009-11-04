require "sass"
require "big_band/integration" # so this is usable without sinatra

class BigBand < Sinatra::Base
  
  # Documentation
  module Sass
    module Functions

      # HACK: Dunno why I have to do both. Have to talk to nex3 or somebody.
      # Including it just in EvaluationContext will not make the methods available
      # from Sass, including it just in Functions will cause Sass to raise an
      # NoMethodError. What causes this behaviour is not obvious from sass/script/functions.rb.
      # More digging though the Sass code should be done.
      ::Sass::Script::Functions::EvaluationContext.send :include, self
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