$LOAD_PATH.unshift File.expand_path(__FILE__ + "/../../lib")
require "big_band"

class Example < BigBand :except => :Reloader

  # The index page. You should see this comment in YARD.
  get "/" do
    haml :index
  end

end