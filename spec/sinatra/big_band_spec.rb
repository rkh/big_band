require File.expand_path(__FILE__ + "/../../spec_helper.rb")

describe Sinatra::BigBand do
  before { app Sinatra::BigBand }

  describe 'sinatra behavior' do
    it_should_behave_like 'sinatra'
  end

  describe "standard extensions" do
    def extension; Sinatra.const_get @ext_name end
    [:AdvancedRoutes, :Compass, :ConfigFile, :MoreServer, :Namespace, :Sugar, :DefaultCharset].each do |ext_name|
      describe ext_name do
        before { @ext_name = ext_name }
        it("should be loaded") { Sinatra.should be_const_defined(ext_name) }
        it("should be set up") { app.should be_a(extension) }
      end
    end
  end
end
