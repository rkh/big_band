require File.expand_path(__FILE__ + "/../../spec_helper.rb")

describe Sinatra::BigBand do
  before { @example_app = nil }

  def set_example_app(options = {})
    @example_app = Class.new Sinatra::BigBand(options)
  end

  def example_app(options = {})
    @example_app = nil unless options.empty?
    @example_app ||= set_example_app options
  end

  describe "standard extensions" do
    def extension; Sinatra.const_get @ext_name end
    [:AdvancedRoutes, :Compass, :ConfigFile, :MoreServer, :Namespace, :Sugar].each do |ext_name|
      describe ext_name do
        before { @ext_name = ext_name }
        it("should be loaded") { Sinatra.should be_const_defined(ext_name) }
        it("should be set up") { example_app.should be_a(extension) }
      end
    end

    [:Compass, :ConfigFile, :MoreServer, :Namespace].each do |ext_name|
      describe ext_name do
        before { @ext_name = ext_name }
        it("should be excludable") { example_app(:except => ext_name).should_not be_a(extension) }
      end
    end
  end
end
