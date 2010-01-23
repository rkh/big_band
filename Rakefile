$LOAD_PATH.unshift "lib"
load "dependencies.rb"

desc "clone all dependencies to vendor"
task :vendor => "vendor:all"
namespace :vendor do
  task :all
  BigBand::Dependencies.each do |dep|
    target = "vendor/#{dep.name}"
    task :all => dep.name
    desc "clone #{dep.name} #{dep.version} to #{target}"
    task dep.name do
      mkdir_p "vendor"
      sh "git clone #{dep.git} #{target}" unless File.exists? target
      chdir(target) do
        sh "git checkout master"
        sh "git pull"
        sh "git checkout #{dep.git_ref}"
      end
    end
  end
end

if ENV['RUN_CODE_RUN']
  Rake::Task["vendor"].invoke
  task :default => :spec
else
  task :default => [:dummy_files, :rip, :gems] # gems will trigger spec
end

$LOAD_PATH.unshift(*Dir.glob(File.expand_path(__FILE__ + "/../vendor/*/lib")))
require "erb"
require "spec/rake/spectask"
require "rake/clean"
require "rake/rdoctask"
require "monkey-lib"
require "yard"

$LOAD_PATH.unshift __FILE__.dirname.expand_path / "lib"
require "big_band/integration/yard"
require "big_band/integration/rake"
require "big_band/version"

include BigBand::Integration::Rake
RoutesTask.new { |t| t.source = "lib/**/*.rb" }

task :install => "gems:install"
task :test    => :spec
task :clobber => "doc:clobber_rdoc"

CLEAN.include "**/*.rbc"
CLOBBER.include "*.gem", "README.rdoc"

Spec::Rake::SpecTask.new('spec') do |t|
  t.spec_opts = %w[--options spec/spec.opts]
  t.spec_files = Dir.glob 'spec/**/*_spec.rb'
end

TOOL_NAMES = { :Rspec => :RSpec, :Yard => :YARD, :TestSpec => :"Test::Spec", :TestUnit => :"Test::Unit" }

def yard(files)
  YARD::Registry.load(Dir[files], true)
  YARD::Registry.resolve(false, "BigBand")
end

def yard_children(ydoc, directory, defaults = {}, &block)
  children = Dir.glob("#{directory}/*.rb").map { |f| f[(directory.size+1)..-4].to_const_string.to_sym }
  children.select!(&block) if block
  children.map! do |name|
    rewritten_name = defaults[name] || name
    ydoc.child(rewritten_name) or ydoc.child(name).tap { |c| c.name = rewritten_name unless c.nil? }
  end
  children.compact
end

def generate_readme(target = "README.rdoc", template = "README.rdoc.erb")
  puts "generating #{target} from #{template}"
  # HACK: loading other libraries later, for some strange heisenbug setting the docstring to an empty string later.
  docstring   = yard("lib/big_band.rb").docstring
  ydoc        = yard("lib/big_band/{**/,}*.rb")
  extensions  = yard_children(ydoc, "lib/big_band") { |n| n != :Integration }
  integration = yard_children(ydoc.child(:Integration), "lib/big_band/integration", TOOL_NAMES) { |n| n != :Test }
  version     = BigBand::VERSION
  File.open(target, "w") { |f| f << ERB.new(File.read(template), nil, "<>").result(binding) }
end

file "README.rdoc" => ["README.rdoc.erb", "lib/big_band.rb"] do
  generate_readme
end

desc "Generate documentation"
task "doc"    => "doc:yardoc"
task "yardoc" => "doc:yardoc"
task "rdoc"   => "doc:yardoc"

namespace :doc do

  task "yardoc" => "readme"
  task "rdoc"   => "readme"
  task "rerdoc" => "readme"

  desc "Generate README.rdoc from source files"
  task "readme" do |t|
    generate_readme
  end

  Rake::RDocTask.new("rdoc") do |rdoc|
    rdoc.rdoc_dir = 'doc'
    rdoc.options += %w[-a -S -N -m README.rdoc -q -w 2 -t BigBand -c UTF-8]
    rdoc.rdoc_files.add ['*.{rdoc,rb}', '{config,lib,routes}/**/*.rb']
  end

  YARD::Rake::YardocTask.new("yardoc") do |t|
    t.options = %w[--main README.rdoc --backtrace]
  end

end

task :gems => "gems:build"

namespace :gems do

  desc "Build gems (runs specs first)"
  task :build => [:clobber, :spec, "doc:readme"] do
    GEMS = []
    Dir.glob("*.gemspec") do |file|
      sh "gem build #{file}"
      GEMS << "#{file[0..-9]}-#{BigBand::VERSION}.gem"
    end
  end

  desc "Install gems"
  task :install => :build do
    GEMS.each { |file| sh "gem install #{file}" }
  end

  desc "Publish gems (gemcutter)"
  task :push => :build do
    GEMS.each { |file| sh "gem push #{file}" }
  end

end

task :rip => "rip:generate"
namespace :rip do
  desc "generates deps.rip"
  task :generate do
    BigBand::Dependencies.for_rip "deps.rip"
  end
end

desc "generate dummy files"
task :dummy_files do |t|
  chdir "lib" do
    rm_rf "sinatra/big_band/"
    mkdir_p "sinatra/big_band/"
    Dir.glob("big_band/**/*.rb") do |file|
      target = "sinatra" / file
      mkdir_p target.dirname
      File.open(target, "w") do |f|
        f.puts "# Generated file, run 'rake #{t.name}' to regenerate"
        f.puts "require #{file[0..-4].inspect}"
      end
    end
  end
end

desc "make a release, will fail if there are uncommitted changes or the specs don't pass"
task :release => "release:gem"
namespace :release do

  task(:committed) do
    status = %x[git status]
    raise "uncommitted changes" unless status =~ /nothing to commit/
    raise "not on branch master" unless status =~ /On branch master\n/
  end

  task :version_bump => [:spec, :committed] do
    new_version = ENV["VERSION"] || BigBand::VERSION.gsub(/\.(\d+)$/) { ".#{$1.to_i + 1}" }
    old_source = File.read "lib/big_band/version.rb"
    File.open("lib/big_band/version.rb", "w") do |f|
      f.puts 'require "big_band/integration" unless defined? BigBand'
      f.puts "BigBand::VERSION = #{new_version.inspect}"
      f.puts "BigBand::DATE    = #{Date.today.to_s.inspect}"
    end
    puts "version bump: #{BigBand::VERSION} -> #{new_version}'"
    BigBand::VERSION.replace new_version
  end

  task :prepare => [:version_bump, :rip, :clobber, "doc:readme", "gems:build"]

  task :git => :prepare do
    message = "-m 'release: #{BigBand::VERSION}'"
    sh "git ci -a #{message}"
    sh "git tag -a v#{BigBand::VERSION} #{message}"
    sh "git push && git push --tags"
  end

  task :gem => [:git, "gems:push"]

end

############
# aliases

task :c => [:clobber, "doc:readme"]
task :s => :spec
task :d
namespace :d do
  task :r => "doc:readme"
  task :y => "doc:yardoc"
end
task :g => :gems
namespace :g do
  task :b => "gems:build"
  task :i => "gems:install"
  task :p => "gems:push"
end
task :r => :rip
namespace(:r) { task :g => "rip:generate" }