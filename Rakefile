# see tasks/*.task for rake tasks

$RELATIVE_LOAD_PATH = Dir.glob '{*,.}/lib'
$LOAD_PATH.unshift('.', *$RELATIVE_LOAD_PATH)
require 'subproject'

task :default => ["setup:check", :spec]

require "rake/clean"
CLEAN.include "**/*.rbc"
CLOBBER.include "*.gem", "doc"

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

def project_task(name, &block)
  return project_namespace { project_task(name, &block) } unless @project
  name, dependencies = name.to_a.first if name.is_a? Hash
  dependencies = [dependencies].flatten.compact
  if @project == :all
    dependencies += Subproject.map { |p| "#{p.name}:#{name}" }
    block = nil
    insert_desc "all subprojects"
  else
    insert_desc @project.name
  end
  if name.to_s == "default"
    @default_desc = Rake.application.last_comment
    desc nil
  end
  task({name => dependencies}, &subproject_block(@project, &block))
end

Dir.glob("tasks/*.task").sort.each do |file|
  eval File.read(file), binding, file, 1
end
