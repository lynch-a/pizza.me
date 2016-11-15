require 'sinatra'

set :port, 80
set :environment, :development
set :server, "thin"
#set :bind, '0.0.0.0'
#set :dump_errors, false

# see http://getskeleton.com/

get '/' do
  erb :index
end

get '/page/:param' do
	erb :page
end