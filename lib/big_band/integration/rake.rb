require "big_band/integration"
require "rake"
require "rake/tasklib"

module BigBand::Integration
  # Some Rake example and description goes here.
  module Rake
    class RoutesTask < ::Rake::TaskLib
      attr_accessor :source, :name

      def initialize(name = :routes)
        @name = name
        @source = BigBand::Integration::GLOBBER
        yield self if block_given
        define
      end

      def define
        desc "Lists routes defined in #{source}"
        task(name) do
          BigBand::Integration.routes_for(source).each do |verb, path|
            puts "#{verb} #{path}"
          end
        end
      end

    end
  end
end