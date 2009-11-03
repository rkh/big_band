require "sinatra/base"
require "big_band/basic_extensions"

class BigBand < Sinatra::Base

  # Advanced reloader for sinatra. Reloads only files that have changed and automatically
  # detects orphaned routes that have to be removed. Files defining routes will be added
  # to the reload list per default. Avoid reloading with dont_reload. Add other files to
  # the reload list with also_reload.
  #
  # Usage:
  #
  #   require "big_band"
  #   class Foo < Sinatra::Base
  #     configure(:development) do
  #       register BigBand::Reloader
  #       also_reload "app/models/*.rb"
  #       dont_reload "lib/**/*.rb"
  #     end
  #   end
  module Reloader

    def self.registered(klass)
      klass.register BasicExtensions
      klass.before do
        if defined? Thread and Thread.list.size > 1 and Thread.respond_to? :exclusive
          Thread.exclusive { klass.reload_routes }
        else
          klass.reload_routes
        end
      end
    end

    def route(verb, path, options={}, &block)
      file = caller_files.first.expand_path
      super.tap do
        signature = signature.signature if signature.respond_to? :signature
        routes_from(file) << [verb, signature] if File.exist? file
      end
    end

    def reload_index
      @routes_index ||= {}
    end

    def routes_from(file)
      (reload_index[file] ||= [File.mtime(file), []]).last
    end

    def reload_routes
      reload_index.each do |file, (mtime, old_routes)|
        next if mtime >= File.mtime(file) or reload_skip_rules.any? { |r| root_glob(r).include? file }
        old_routes.each { |verb, signature| (routes[verb] ||= []).delete signature }
        $LOADED_FEATURES.delete file
        old_routes.clear
        require file if File.exist? file
      end
    end
    
    def reload_skip_rules
      @reload_skip_rules ||= []
    end
    
    def dont_reload(files)
      reload_skip_rules << files
    end
    
    def also_reload(files)
      root_glob(files) { |file| routes_from(file) }
    end

  end
end