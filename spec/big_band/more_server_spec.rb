require File.expand_path(__FILE__ + "/../../spec_helper.rb")

describe BigBand::MoreServer do
  before { app :MoreServer }
  it("should offer unicorn")   { app.server.should include("unicorn")  }
  it("should offer rainbows")  { app.server.should include("rainbows") }
end