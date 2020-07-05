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
      redirect '/login/patient'
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
    if ApplicationController.is_logged_in?(session)
      @patient = ApplicationController.current_user(session)
        erb :'/patients/new'
    else
      erb :welcome
    end
  end

  get '/sessions/logout' do
    session.clear
    erb :welcome
  end

  get '/home/patient' do
    erb :'/patients/home/patient'
  end


end
