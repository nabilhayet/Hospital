class PatientsController < ApplicationController
  configure do
    enable :sessions unless test?
    set :session_secret, "secret"
  end

  get '/registrations/patient' do
    erb :'patients/registration/patient'
  end

  post '/registrations' do
    @patient = Patient.new(name: params["name"], email: params["email"], password: params["password"])
    @patient.save
    session[:patient_id] = @patient.id

    redirect '/home/patient'
  end

  get '/login/patient' do
    erb :'/patients/login/patient'
  end

  post '/login' do
    @patient = Patient.find_by(email: params[:email], password: params[:password])
    if @patient
      session[:patient_id] = @patient.id
      redirect '/profile/patient'
    end
    redirect '/login/patient'
  end

  get '/profile/patient' do
    erb :'/patients/new'
  end

  get '/sessions/logout' do
    session.clear
    erb :'/patients/home/patient'
  end

  get '/home/patient' do
    erb :'/patients/home/patient'
  end


end
