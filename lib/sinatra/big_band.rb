require 'async-rack'
require 'monkey-lib'
require 'rack/flash'
require 'sinatra/base'
require 'sinatra/sugar'
require 'sinatra/advanced_routes'
require 'sinatra/compass'
require 'sinatra/config_file'
require 'sinatra/default_charset'
require 'sinatra/more_server'
require 'sinatra/namespace'

module Sinatra
  Base.ignore_caller
  class BigBand < Base
    use Rack::Flash, :flash_app_class => self

    register Sinatra::Sugar
    register Sinatra::AdvancedRoutes
    register Sinatra::Compass
    register Sinatra::ConfigFile
    register Sinatra::DefaultCharset
    register Sinatra::MoreServer
    register Sinatra::Namespace

    configure(:development) do
      require 'sinatra/reloader'
      register Sinatra::Reloader
    end

    set :app_file, caller_files.first.expand_path unless app_file?
    set :haml, :format => :html5, :escape_html => true
    enable :sessions, :method_override, :show_exceptions
  end
end
