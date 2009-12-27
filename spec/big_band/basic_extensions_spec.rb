require File.expand_path(__FILE__ + "/../../spec_helper.rb")

describe BigBand::BasicExtensions do

  before { app :BasicExtensions }

  describe "set" do

    it "adds hooks to Sinatra::Base#set" do
      extension = Module.new
      extension.should_receive(:set_foo).with(app)
      extension.should_receive(:set_value).with(app, :foo)
      app.register extension
      app.set :foo, 42
    end

    it "allows passing a block" do
      app.set(:foo) { 42 }
      app.foo.should == 42
    end

    it "merges hash values" do
      app.set :foo, :bar => 42
      app.set :foo, :baz => 23
      app.foo[:bar].should == 42
      app.foo[:baz].should == 23
    end

  end

  describe "register" do
    it "registers an extension only once" do
      extension = Module.new
      extension.should_receive(:registered).once.with(app)
      10.times { app.register extension }
    end
  end

end