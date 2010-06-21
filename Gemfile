source :rubygems

gem 'rack', '= 1.1.0' # 1.2 has issues
gem 'haml'
gem 'compass'
gem 'rack-test'
gem 'yard', "~> 0.5.3"
gem 'sinatra-default_charset', '>= 0.2.0'
gem 'rack-flash', '>= 0.1.1'
gem 'rspec', '~> 1.3.0'
gem 'rake', '>= 0.8.7'
gem 'bundler', '>= 0.9'

# could have used groups, but this is easier. plays nice with hudson.
if ENV['SINATRA'] == 'sinatra master' then gem 'sinatra', :git => "git://github.com/sinatra/sinatra.git"
else gem 'sinatra', '>= 1.0'
end

ext = ENV['EXT'] || 'backports'
gem(*ext.split(' '))
