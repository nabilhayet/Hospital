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

  get '/logout' do
    session.clear
    redirect '/'
  end

  def current_user
    if session.key?("patient_id")
      @p = Patient.find_by_id(session[:patient_id])
      @p
    else
      @d = Doctor.find_by_id(session[:doctor_id])
      @d
    end
  end

  def is_logged_in?
    if session.key?("patient_id")
      !!session[:patient_id]
    else
      !!session[:doctor_id]
    end
  end

  def current_user_type
    current_user.class.name
  end
end
