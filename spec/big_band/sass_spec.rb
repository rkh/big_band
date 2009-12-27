require File.expand_path(__FILE__ + "/../../spec_helper.rb")

describe BigBand::Sass do

  def evaluate_sass(value)
    Sass::Script::Parser.parse(value, 0, 0).perform(Sass::Environment.new).to_s
  end

  it "returns the smaller value for min" do
    evaluate_sass("min(10px, 20px)").should == evaluate_sass("10px")
    evaluate_sass("min(50%, 10%)").should == evaluate_sass("10%")
    evaluate_sass("min(42, 42)").should == evaluate_sass("42")
  end

  it "returns the greater value for max" do
    evaluate_sass("max(10px, 20px)").should == evaluate_sass("20px")
    evaluate_sass("max(50%, 10%)").should == evaluate_sass("50%")
    evaluate_sass("max(42, 42)").should == evaluate_sass("42")
  end

end