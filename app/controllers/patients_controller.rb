class PatientsController < ApplicationController


  get '/registrations/patient' do
    erb :'patients/registration/patient'
  end

  post '/registrations' do
    @patient = Patient.find_by(email: params["email"])
    if @patient
      flash.next[:message] = "Email address already exists."
      redirect '/registrations/patient'
    else
      @patient = Patient.new(name: params["name"], email: params["email"], password: params["password"])
      @patient.save
      flash.next[:message] = "Successfully registered."
      session[:patient_id] = @patient.id
      redirect '/home/patient'
    end
  end

  get '/login/patient' do
    erb :'/patients/login/patient'
  end

  post '/login' do
    @patient = Patient.find_by(email: params[:email])
    if @patient && @patient.authenticate(params[:password])
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
