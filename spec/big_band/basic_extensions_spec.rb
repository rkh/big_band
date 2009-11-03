require File.expand_path(__FILE__ + "../../../spec_helper.rb")

describe BigBand::BasicExtensions do

  describe "set" do
    it "adds hooks to Sinatra::Base#set"
    it "allows passing a block"
    it "merges hash values"
  end

  describe "register" do
    it "registers an extension only once"
  end

  describe "sass" do
    it "should set content type for css, if none is set"
    it "should not set any content type if a content type is already defined"
  end

end