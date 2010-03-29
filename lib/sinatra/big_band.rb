require 'sinatra/base'
require "sinatra/sugar"
require 'async-rack'
require 'monkey'

module Sinatra
  Base.ignore_caller

  class BigBand < Base
    def self.subclass_extensions
      @subclass_extensions ||= {}
    end

    def self.extension(path, development_only = false, parent = Sinatra)
      name = path.to_s.split('_').map { |e| e.capitalize }.join.to_sym
      subclass_extensions[name] ||= [parent, name, development_only]
      parent.autoload name, "#{parent.name.downcase}/#{path}"
    end

    extension :advanced_routes
    extension :compass
    extension :config_file
    extension :more_server
    extension :namespace
    extension :reloader, true
    extension :sugar
    extension :web_inspector, true

    def self.generate_subclass(options = {})
      options[:except] ||= []
      options.keys.each { |k| raise ArgumentError, "unkown option #{k.inspect}" unless k == :except }
      options[:except] = [*options[:except]]
      list = subclass_extensions.inject [] do |chosen, (ident, (parent, name, dev))|
        next chosen if options[:except].include? ident or (dev and not development?)
        chosen << parent.const_get(name)
      end
      @subclasses ||= {}
      @subclasses[list] ||= Class.new(self) do
        define_singleton_method(:inherited) do |klass|
          super klass
          list.each { |e| klass.register e }
          klass.set :app_file, klass.caller_files.first.expand_path unless klass.app_file?
          klass.set :haml, :format => :html5, :escape_html => true
        end
      end
    end
  end

  def self.BigBand(options = {})
    BigBand.generate_subclass(options)
  end
end
