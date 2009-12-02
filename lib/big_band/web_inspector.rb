require "sinatra/base"
require "monkey-lib"
require "big_band/compass"

class BigBand < Sinatra::Base

  # Documentation
  module WebInspector

    attr_reader :middleware 

    class Middleware < Sinatra::Base

      attr_accessor :sinatra_app
      use_in_file_templates! __FILE__
      register BasicExtensions
      set :app_file, __FILE__

      get "/__inspect__/screen.css" do
        content_type 'text/css', :charset => 'utf-8'
        sass :stylesheet, ::Compass.sass_engine_options
      end

      get "/__inspect__/?" do
        git_log = false
        unless root_glob("{../,../../,}.git").empty?
          format = ["<a href='mailto:%ae'>%an</a>", "%s", "<date>%ai</date>"]
          format.map! { |e| "<td>#{e}</td>" }
          git_log = %x[git log --pretty=format:"<tr>#{format.join}</tr>"]
          git_log = false if git_log.empty?
        end
        ruby_env = %w[RUBY_VERSION RUBY_DESCRIPTION RUBY_PATCHLEVEL RUBY_PLATFORM RUBY_ENGINE RUBY_ENGINE_VERSION]
        ruby_env.map! { |var| [var, eval("#{var}.inspect if defined? #{var}")] }
        haml :inspect, {}, :ruby_env => ruby_env, :git_log => git_log
      end

    end

    def self.registered(klass)
      klass.register BasicExtensions
      klass.register AdvancedRoutes
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
    %link{:rel => "stylesheet", :href => "/__inspect__/screen.css", :type => "text/css"}/
    %title= "#{sinatra_app.name}.inspect"
  %body
    %header
      %h1= "#{sinatra_app.name}.inspect"
      Generated on
      %date= Time.now
      %nav
        %a{:href => "/__inspect__/#routes"     } Routes
        %a{:href => "/__inspect__/#extensions" } Extensions
        %a{:href => "/__inspect__/#middleware" } Middleware
        %a{:href => "/__inspect__/#system"     } System
        - if git_log
          %a{:href => "/__inspect__/#git_log"  } Git Log
    %article
      !=yield
    %footer
      powered by
      %a{:href => "http://www.sinatrarb.com"} Sinatra
      and
      %a{:href => "http://github.com/rkh/big_band"} BigBand

@@stylesheet
@import big_band/layouts/inspector.sass
+layout_inspector

@@inspect

%a{ :name => "routes" }
%h2 Routes
%table
  %tr
    %th Verb
    %th Pattern
    %th File
    %th Keys
    %th Conditions
  - sinatra_app.each_route do |route|
    %tr
      %td= route.verb
      %td= route.pattern.inspect
      %td
        - if route.file?
          = route.file
          %i= "(line #{route.line})" if route.line 
      %td= route.keys.map { |e| e.inspect }.join ", "
      %td= route.conditions.map { |e| e.inspect }.join ", "

%a{ :name => "extensions" }
%h2 Extensions
%table
  %tr
    %th Extension
    %th Status
  - sinatra_app.extensions.each do |extension|
    %tr
      %td= extension.name
      %td= extension.status if extension.respond_to? :status

%a{ :name => "middleware" }
%h2 Middleware
%table
  %tr
    %th Middleware
    %th Arguments
    %th Block Given
  - sinatra_app.middleware.each do |name, arguments, block|
    %tr
      %td= name
      %td= arguments.map { |e| e.inspect }.join ", "
      %td= block ? "yes" : "no"

%a{ :name => "system" }
%h2 System
%table
  %tr
    %th Variable
    %th Value
  - ruby_env.each do |key, value|
    %tr
      %td= key
      %td= value

- if git_log
  %a{ :name => "git_log" }
  %h2 Recent Git Log
  - else
    %table
      %tr
        %th Author
        %th Subject
        %th Date
        != git_log
