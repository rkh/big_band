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

    def self.subclass_extension(path, development_only = false, parent = Sinatra, &block)
      name = path.to_s.split('_').map { |e| e.capitalize }.join.to_sym
      subclass_extensions[name] ||= [parent, name, development_only, block]
      parent.autoload name, "#{parent.name.downcase}/#{path}"
    end

    subclass_extension :advanced_routes
    subclass_extension :compass
    subclass_extension :config_file
    subclass_extension :more_server
    subclass_extension :namespace
    subclass_extension :reloader, true
    subclass_extension :sugar
    subclass_extension :web_inspector, true

    def self.apply_options(klass)
      klass.set :app_file, klass.caller_files.first.expand_path unless klass.app_file?
      klass.set :haml, :format => :html5, :escape_html => true
      enable :sessions
    end

    def self.subclass_for(list)
      @subclasses ||= {}
      @subclasses[list] ||= Class.new(self) do
        define_singleton_method(:inherited) do |klass|
          super klass
          list.each { |block| block.call klass }
          apply_options klass
        end
      end
    end

    def self.generate_subclass(options = {})
      options[:except] ||= []
      options.keys.each { |k| raise ArgumentError, "unkown option #{k.inspect}" unless k == :except }
      options[:except] = [*options[:except]]
      list = subclass_extensions.inject([]) do |chosen, (ident, (parent, name, dev))|
        next chosen if options[:except].include? ident or (dev and not development?)
        extension = parent.const_get name
        chosen << proc { |klass| klass.register extension }
      end
      subclass_for list
    end
  end

  def self.BigBand(options = {})
    BigBand.generate_subclass(options)
  end
end
