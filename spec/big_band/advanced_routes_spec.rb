require File.expand_path(__FILE__ + "../../../spec_helper.rb")

describe BigBand::AdvancedRoutes do
  before { app :AdvancedRoutes }

  [:get, :head, :post, :put, :delete].each do |verb|

    describe "HTTP #{verb.to_s.upcase}" do

      describe "activation" do

        it "is able to deactivate routes from the outside" do
          route = define_route(verb, "/foo") { "bar" }
          route.should be_active
          browse_route(verb, "/foo").should be_ok
          route.deactivate
          route.should_not be_active
          browse_route(verb, "/foo").should_not be_ok
        end

        it "is able to deacitvate routes from a before filter" do
          route = define_route(verb, "/foo") { "bar" }
          app.before { route.deactivate }
          route.should be_active
          browse_route(verb, "/foo").should_not be_ok
          route.should_not be_active
        end

        it "is able to reactivate deactivated routes" do
          route = define_route(verb, "/foo") { "bar" }
          route.deactivate
          route.activate
          route.should be_active
          browse_route(verb, "/foo").should be_ok
        end

      end

      describe "inspection" do
        it "exposes app, path, file, verb, pattern, " do
          route = define_route(verb, "/foo") { }
          route.app.should        == app
          route.path.should       == "/foo"
          route.file.should       == __FILE__.expand_path
          route.verb.should       == verb.to_s.upcase
          route.pattern.should    == route[0]
          route.keys.should       == route[1]
          route.conditions.should == route[2]
          route.block.should      == route[3]
        end
      end

      describe "promotion" do
        it "preffers promoted routes over earlier defined routes" do
          next if verb == :head # cannot check body for head
          bar = define_route(verb, "/foo") { "bar" }
          baz = define_route(verb, "/foo") { "baz" }
          browse_route(verb, "/foo").body.should == "bar"
          baz.promote
          browse_route(verb, "/foo").body.should == "baz"
          bar.promote
          browse_route(verb, "/foo").body.should == "bar"
        end
      end

    end

  end

end