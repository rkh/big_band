ENV['RACK_ENV'] = 'test'

$LOAD_PATH.unshift File.expand_path(__FILE__ + "../../lib")
require "big_band/integration/rspec"