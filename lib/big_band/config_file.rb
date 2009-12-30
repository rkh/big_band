require "sinatra/base"
require "yaml"

class BigBand < Sinatra::Base
  # Using YAML config files. Config files are expected to represent hashes.
  # When parsing such a config file it will use set to store that value, ignoring
  # those directly defined in the app (not those defined by the class it inherits
  # from, i.e. Sinatra::Base or BigBand).
  #
  # Example:
  #
  #   class MyApp << BigBand
  #     set :foo, "bar"
  #     config_file "settings.yml"                 # general settings
  #     config_file "#{environment}.settings.yml"  # environment specific settings
  #     foo # => "bar"
  #   end
  #
  # Now you could write in your settings.yml:
  #
  #   ---
  #   server: [thin, webrick] # use only thin or webrick for #run!
  #   public: /var/www        # load public files from /var/www
  #   port:   8080            # run on port 8080
  #   foo: baz
  #   database:
  #     adapter: sqlite
  #
  # In you development.settings.yml:
  #
  #   database:
  #     db_file: development.db
  module ConfigFile

    def self.registered(klass)
      klass.register BasicExtensions
    end

    def config_file(*paths)
      paths.each do |pattern|
        files = root_glob(pattern.to_s)
        files.each { |f| YAML.load_file(f).each_pair { |k,v| set k, v unless respond_to? k } }
        warn "WARNING: could not load config file #{pattern}" if files.empty?
      end
    end

  end
end