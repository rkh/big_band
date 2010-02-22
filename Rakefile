# see tasks/*.task for rake tasks

$RELATIVE_LOAD_PATH = Dir.glob '{*,.}/lib'
$LOAD_PATH.unshift(*$RELATIVE_LOAD_PATH)

task :default => "setup:read_only" if ENV['RUN_CODE_RUN']
task :default => ["setup:check", :spec]

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

  new "haml-more"
  new "monkey-lib"
  new "sinatra-advanced-routes"
  new "sinatra-compass"
  new "sinatra-config-file"
  new "sinatra-more-server"
  new "sinatra-namespace"
  new "sinatra-reloader"
  new "sinatra-sugar"
  new "sinatra-test-helper"
  new "sinatra-web-inspector"
  new "yard-sinatra"

end

def insert_desc(*values)
  return unless Rake.application.last_comment
  Rake.application.last_comment.replace(Rake.application.last_comment % values)
end

def project_namespace(parent = nil, all = true, &block)
  return namespace(parent) { project_namespace(nil, all, &block) } if parent
  project_was, default_desc_was = @project, @default_desc
  namespaces = Subproject.inject({}) { |h, p| h.merge p.name => p}
  namespaces[all == true ? nil : all] = :all if all
  namespaces.each do |name, project|
    @project, @default_desc = project, false
    if name
      namespace(name, &block)
      if @default_desc
        desc @default_desc
        task name => "#{name}:default"
      end
    else
      yield
    end
  end
  @project, @default_desc = project_was, default_desc_was
end

def subproject
  @subproject
end

def subproject_block(project)
  proc do |raketask|
    @subproject, subproject_was = project, @subproject
    yield raketask if block_given?
    @subproject = subproject_was
  end
end

def project_task(name, klass = nil, &block)
  return project_namespace { project_task(name, klass, &block) } unless @project
  name, dependencies = name.first if name.is_a? Hash
  dependencies = [dependencies].flatten.compact
  if @project == :all
    dependencies += Subproject.map { |p| "#{p.name}:#{name}" }
    klass, block = nil, nil
    insert_desc "all subprojects"
  else
    insert_desc @project.name
  end
  if name.to_s == "default"
    @default_desc = Rake.application.last_comment
    desc nil
  end
  task name => dependencies
  if klass then klass.new(name, &subproject_block(@project, &block))
  else task(name, &subproject_block(@project, &block))
  end
end

Dir.glob("tasks/*.task").sort.each do |file|
  eval File.read(file), binding, file, 1
end
