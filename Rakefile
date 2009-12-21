require "erb"
require "spec/rake/spectask"
require "rake/clean"
require "rake/rdoctask"
require "monkey-lib"
require "yard"

$LOAD_PATH.unshift __FILE__.dirname / "lib"

require "big_band/integration/yard"

task :default => :spec
task :test => :spec
task :clobber => "doc:clobber_rdoc"

CLOBBER << "README.rdoc"

def yard(files)
  YARD::Registry.load(Dir[files], true)
  YARD::Registry.resolve(false, "BigBand")
end

def yard_children(ydoc, directory, &block)
  children = Dir.glob("#{directory}/*.rb").map { |f| f[(directory.size+1)..-4].to_const_string.to_sym }
  children.select!(&block) if block
  children.map { |name| ydoc.child name }
end

def generate_readme(target = "README.rdoc", template = "README.rdoc.erb")
  # HACK: loading other libraries later, for some strange heisenbug setting the docstring to an empty string later.
  docstring   = yard("lib/big_band.rb").docstring
  ydoc        = yard("lib/big_band/{**/,}*.rb")
  extensions  = yard_children(ydoc, "lib/big_band") { |n| n != :Integration }
  integration = yard_children ydoc.child(:Integration), "lib/big_band/integration"
  File.open(target, "w") { |f| f << ERB.new(File.read(template), nil, "<>").result(binding) }
end

file "README.rdoc" => ["README.rdoc.erb", "lib/big_band.rb"] do
  generate_readme
end

desc "generate documentation"
task "doc"    => "doc:yardoc"
task "yardoc" => "doc:yardoc"
task "rdoc"   => "doc:yardoc"

namespace :doc do

  task "yardoc" => "readme"
  task "rdoc"   => "readme"
  task "rerdoc" => "readme"

  desc "generate README.rdoc from source files"
  task "readme" do |t|
    generate_readme
  end

  Rake::RDocTask.new("rdoc") do |rdoc|
    rdoc.rdoc_dir = 'doc'
    rdoc.options += %w[--all --inline-source --line-numbers --main README.rdoc --quiet
                       --tab-width 2 --title BigBand --charset UTF-8]
    rdoc.rdoc_files.add ['*.{rdoc,rb}', '{config,lib,routes}/**/*.rb']
  end
  
  YARD::Rake::YardocTask.new("yardoc") do |t|
    t.options = %w[--main README.rdoc]
  end

end

Spec::Rake::SpecTask.new('spec') do |t|
  t.spec_opts = %w[--options spec/spec.opts]
  t.spec_files = Dir.glob 'spec/**/*_spec.rb'
end