warn "#{caller.detect { |c| c !~ /require/ }}: require 'big_band' is deprecated, use require 'sinatra/big_band' instead."
require "sinatra/big_band"

def BigBand(*args, &block)
  warn "#{caller.first}: Using BigBand is deprecated, use Sinatra::BigBand instead. It will be removed in BigBand 0.5."
  Monkey.invisible { Sinatra::BigBand(*args, &block) }
end

Module.class_eval do
  alias const_missing_without_deprecation_warnings const_missing
  def const_missing(name)
    Monkey.invisible __FILE__ do
      return const_missing_without_deprecation_warnings(name) unless name == :BigBand and self != ::Sinatra
      from = caller.detect { |e| e !~ /const_missing/ }
      warn "#{from}: Using BigBand is deprecated, use Sinatra::BigBand instead. It will be removed in BigBand 0.5."
      Sinatra::BigBand
    end
  end
end
