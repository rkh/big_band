$LOAD_PATH.unshift(File.expand_path(__FILE__ + "/../../lib"), *Dir.glob(File.expand_path(__FILE__ + "/../../vendor/*/lib")))
require "big_band"

class Example < BigBand

  # The index page. You should see this comment in YARD.
  get "/" do
    haml :index
  end
  
  run! if run?

end