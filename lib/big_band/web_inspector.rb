require "sinatra/base"
require "monkey-lib"

class BigBand < Sinatra::Base
  
  # Documentation
  module WebInspector
    
    attr_reader :middleware
    
    class Middleware < Sinatra::Base
      use_in_file_templates! __FILE__
      register BasicExtensions
      set :sinatra_app, BigBand
      set :app_file, __FILE__
      set :views, root_path("web_inspector")
      get "/__inspect__" do
        haml :inspect, {},
          :title      => sinatra_app.name + ".inspect",
          :name       => sinatra_app.name,
          :extensions => sinatra_app.extensions,
          :routes     => sinatra_app.routes,
          :middleware => sinatra_app.middleware
      end
    end
    
    def self.registered(klass)
      klass.use(Middleware) { |m| m.sinatra_app = klass }
    end

  end
end

__END__

@@layout
!!!
%html
  %head
    %meta{:charset=>"utf-8"}/
    %title= title
  %body
    %header
      %h1= title
      Generated on
      %date= Time.now
    %article
      =yield
    %footer
      powered by
      %a{:href => "http://www.sinatrarb.com"} Sinatra
      and
      %a{:href => "http://github.com/rkh/big_band"} BigBand

@@inspect