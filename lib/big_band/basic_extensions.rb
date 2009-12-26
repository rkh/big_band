require "sinatra/base"
require "monkey-lib"

class BigBand < Sinatra::Base

  CALLERS_TO_IGNORE = (class << Sinatra::Base; CALLERS_TO_IGNORE; end) unless defined? CALLERS_TO_IGNORE
  Dir.chdir __FILE__.dirname.dirname do
    Dir.glob("**/*.rb") { |file| CALLERS_TO_IGNORE << Regexp.new(Regexp.escape(file)) }
  end

  # Basic Sinatra extension (mainly extending Sinatra's standard methods, like set or register).
  # Also it features a more advanced path guessing than Sinatra::Base.
  # Normally you do not have to register this module manually, as the other extensions will do so
  # if necessary.
  module BasicExtensions
    module ClassMethods

      attr_writer :root, :guessed_root

      # More advanced set:
      # - Adds set_#{key} and set_value hooks to set.
      # - Merges the old value with the new one, if both are hashes:
      #     set :haml, :format => :html5, :escape_html => true
      #     set :haml, :excape_html => false
      #     haml # => { :format => :html5, :escape_html => false }
      # - Allowes passing a block:
      #     set(:foo) { Time.now }
      # - Defines a helper to access #{key} and #{key}? unless a helper/method with that name already exists.
      def set(key, value = self, &block)
        # FIXME: refactor, refactor, refactor
        if block_given?
          raise ArgumentError, "both a value and a block given" if value != self
          value = block
        end
        symbolized = (key.to_sym if key.respond_to? :to_sym)
        old_value = (send(symbolized) if symbolized and respond_to? symbolized)
        value = old_value.merge value if value.is_a? Hash and old_value.is_a? Hash
        super(key, value)
        if symbolized
          method_names = instance_methods.map { |m| m.to_s }
          define_method(key)       { self.class.send(key)       } unless method_names.include? key.to_s
          define_method("#{key}?") { self.class.send("#{key}?") } unless method_names.include? "#{key}?"
        end
        # HACK: Sinatra::Base.set uses recursion and in the final step value always
        # is a Proc. Also, if value is a Proc no step ever follows. I abuse this to
        # invoke the hooks only once per set.
        if value.is_a? Proc
          invoke_hook "set_#{key}", self
          invoke_hook :set_value, self, key
        end
        self
      end

      # More advacend register:
      # - If an exntesion is registered twice, the registered hook will only be called once.
      def register(*extensions, &block)
        extensions.reject! { |e| self.extensions.include? e }
        super(*extensions, &block)
      end

      # Short hand so you can skip those ugly File.expand_path(File.join(File.dirname(__FILE__), ...))
      # lines.
      def root_path(*args)
        relative = File.join(*args)
        return relative if relative.expand_path == relative
        root.expand_path / relative
      end

      # Like root_path, but does return an array instead of a string. Optionally takes a block that will
      # be called for each entry once.
      #
      # Example:
      #   class Foo < BigBand
      #     root_glob("app", "{models,views,controllers}", "*.rb") { |file| load file }
      #   end
      def root_glob(*args, &block)
        Dir.glob(root_path(*args), &block)
      end

      # Whether or not to start a webserver.
      def run?
        @run ||= true
        @run and !@running and app_file? and $0.expand_path == app_file.expand_path
      end

      # Disable automatically running this class as soon it is subclassed.
      def inherited
        super
        @run = false
      end

      # The application's root directory. BigBand will guess if missing.
      def root
        return ".".expand_path unless app_file?
        return @root if @root
        @guessed_root ||= begin
          dir = app_file.expand_path.dirname
          if dir.basename == "lib" and not (dir / "lib").directory?
            dir.dirname
          else
            dir
          end
        end
      end

      # Returns true if the #root is known.
      def root?
        !!@root || app_file?
      end

      # Option parser for #run!
      def run_option_parser
        @run_option_parser ||= begin
          require 'optparse'
          OptionParser.new do |op|
            op.on('-x')        {       set :lock, true }
            op.on('-e env')    { |val| set :environment, val.to_sym }
            op.on('-s server') { |val| set :server, val }
            op.on('-p port')   { |val| set :port, val.to_i }
          end 
        end
      end

      # Extended #run!, offers an extandable option parser for
      # BigBand with the same standard options as the one of
      # Sinatra#Default (see #run_option_parser).
      def run!(options = {})
        run_option_parser.parse!(ARGV.dup) unless ARGV.empty?
        @running = true
        super(options)
      end

    end

    module InstanceMethods

      # See BigBand::BasicExtentions::ClassMethods#root_path
      def root_path(*args)
        self.class.root_path(*args)
      end

      # See BigBand::BasicExtentions::ClassMethods#root_path
      def root_glob(*args, &block)
        self.class.root_glob(*args, &block)
      end

      # See BigBand::BasicExtentions::ClassMethods#root
      def root
        self.class.root
      end

      # See BigBand::BasicExtentions::ClassMethods#root?
      def root?
        self.class.root
      end

    end

    def self.registered(klass)
      klass.set :app_file, klass.caller_files.first.expand_path unless klass.app_file?
      klass.extend ClassMethods
      klass.send :include, InstanceMethods
      klass.set :haml, :format => :html5, :escape_html => true
      klass.use Rack::Session::Cookie
      klass.enable :sessions
      klass.get %r{/__big_band__/([^\.]+(\.[^\.]+)?)} do
        send_file(__FILE__.expand_path.dirname / :files / params[:captures].first)
      end
    end

    def self.set_app_file(klass)
      klass.guessed_root = nil
    end

  end
end