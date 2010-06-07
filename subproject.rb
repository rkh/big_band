require 'ostruct'

class Subproject < OpenStruct
  extend Enumerable
  @list ||= []

  def self.each(&block)
    @list.each(&block)
  end

  def self.new(name, options = {})
    options[:public_remote]  ||= "git://github.com/rkh/#{name}.git"
    options[:private_remote] ||= "git@github.com:rkh/#{name}.git"
    options.merge! :name => name
    result = super options
    yield result if block_given?
    @list << result
    result
  end

  def self.names
    map { |p| p.name }
  end

  def self.[](name)
    detect { |p| p.name == name }
  end

  new "async-rack"
  new "haml-more"
  new "monkey-lib"
  new "sinatra-advanced-routes"
  new "sinatra-compass"
  new "sinatra-config-file"
  new "sinatra-extension"
  new "sinatra-more-server"
  new "sinatra-namespace"
  new "sinatra-reloader"
  new "sinatra-sugar"
  new "sinatra-test-helper"
  new "yard-sinatra"

end