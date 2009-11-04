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

end