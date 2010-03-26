require File.expand_path(__FILE__ + "/../../spec_helper.rb")

describe Sinatra::BigBand do
  before { @example_app = nil }

  def set_example_app(*options)
    @example_app = Class.new Sinatra::BigBand(*options)
  end

  def example_app
    @example_app ||= set_example_app
  end

  describe "standard extensions" do
    [:AdvancedRoutes, :Compass, :ConfigFile, :MoreServer, :Namespace, :Sugar].each do |ext_name|
      describe ext_name do
        before { @ext_name = ext_name }

        def extension
          pending
          extension = Sinatra.const_get @ext_name
        end

        it "should be loaded" do
          pending
          Sinatra.should be_const_defined(ext_name)
        end

        it "should be set up" do
          pending
          example_app.should be_a(extension)
        end
      end
    end
  end
end
