# encoding: utf-8

require "big_band/integration"
require "rake"
require "rake/tasklib"

module BigBand::Integration
  # In your Rakefile, do the following:
  #
  #   require "big_band/integration/rake"
  #   include BigBand::Integration::Rake
  #
  #   RoutesTask.new
  #
  # then you can run 'rake routes' from your
  # project directory and it will list all routes
  # of your app. Per default it will scan for routes
  # defined in ruby files in the directories lib, app,
  # routes, models, views, and controllers (ignoring
  # non-existant directories, of course). You can change
  # that behavior by setting +source+ to another pattern:
  #
  #   RoutesTask.new { |t| t.source = "**/*.rb" }
  #
  # However, you may also just pass in a Sinatra app, so it
  # will not have to scan through the source files:
  #
  #   require "my_app"
  #   RoutesTask.new { |t| t.source = MyApp }
  #
  # Keep in mind that a broken my_app in this case would also make
  # your Rakefile unusable.
  #
  # Also, you may set another name for the task either by setting
  # the first argument or calling #name=:
  #
  #   RoutesTask.new(:some_routes) { |t| t.source = SomeApp }
  #   RoutesTask.new do |t|
  #     t.source = AnotherApp
  #     t.name   = :other_routes
  #   end
  module Rake
    class RoutesTask < ::Rake::TaskLib
      attr_accessor :source, :name

      def initialize(name = :routes)
        @name = name
        @source = BigBand::Integration::GLOBBER
        yield self if block_given?
        define
      end

      def define
        desc "Lists routes defined in #{source}"
        task(name) do
          list = []
          width = 0
          BigBand::Integration.each_route(source) do |verb, route|
            docstring = ""
            docstring << route.file if route.file?
            docstring << ":" << route.line if route.line
            if route.docstring
              docstring << " " unless docstring.empty?
              docstring << route.docstring
            end
            signature = "#{verb.downcase}(#{route.path.inspect})"
            list << [signature, docstring]
            width = [signature.size, width].max
          end
          list.each do |signature, docstring|
            line = "#{signature.ljust width}   # #{docstring}"
            line = line[0..99] + "…" if line.size > 100
            puts line
          end
        end
      end

    end
  end
end