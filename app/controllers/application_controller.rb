require './config/environment'
require 'sinatra'
require 'sinatra/base'
require 'sinatra/flash'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions unless test?
    set :session_secret, "secret"
    register Sinatra::Flash
  end


  get "/" do
    erb :welcome
  end

end
