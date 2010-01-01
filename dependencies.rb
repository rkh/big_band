# Manages dependencies for different package management systems in a single place (I like to experiment).
dependencies = proc do
  dep "compass",    :git => "git://github.com/chriseppstein/compass.git", :version => "0.8.17", :git_ref => "v%s"
  dep "monkey-lib", :git => "git://github.com/rkh/monkey-lib.git",        :version => "0.3.2",  :git_ref => "v%s"
  dep "rack",       :git => "git://github.com/rack/rack.git",             :version => "1.0.1",  :only    => :rip
  dep "rack-test",  :git => "git://github.com/brynary/rack-test.git",     :version => "0.5.3",  :git_ref => "v%s"
  dep "sinatra",    :git => "git://github.com/sinatra/sinatra.git",       :version => "0.9.4"
  dep "yard",       :git => "git://github.com/lsegal/yard.git",           :version => "0.5.2"
end

require "ostruct"
require "big_band/integration" unless defined? BigBand

module BigBand::Dependencies
  @deps = {}
  extend Enumerable

  def self.dep(name = nil, data = {})
    return(@deps[name] ||= OpenStruct.new) if data.empty?
    data[:git_ref] ||= data[:version]
    data[:only]    ||= [:rip, :gem]
    data[:name]    ||= name
    data[:only]      = [data[:only]] unless data[:only].is_a? Array
    data[:git_ref]   = data[:git_ref] % data[:version]
    @deps[name]      = OpenStruct.new data
  end

  def self.for_gemspec(s)
    each { |d| s.add_dependency d.name, ">= #{d.version}" }
  end

  def self.for_rip(file = nil)
    if file then File.open(file, "w") { |f| f << for_rip }
    else select { |d| d.only.include? :rip }.map { |d| "#{d.git} #{d.git_ref}\n"}.join
    end
  end

  def self.each(&block)
    @deps.each_value(&block)
  end

end

BigBand::Dependencies.class_eval(&dependencies)
