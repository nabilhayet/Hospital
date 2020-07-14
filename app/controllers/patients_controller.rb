class PatientsController < ApplicationController

  get '/registrations/patient' do
    erb :'patients/registration/patient'
  end

  post '/registration/patient' do
    @patient = Patient.find_by(email: params["email"])
      if @patient
        flash.next[:message] = "Email address already exists."
        redirect '/registrations/patient'
      else
        @patient = Patient.new(name: params["name"], email: params["email"], password: params["password"])
          if @patient.save
            flash.next[:message] = "Successfully registered."
            session[:patient_id] = @patient.id
            redirect '/login/patient'
          else
            flash.next[:message] = "Please fill out form correctly!"
            redirect 'registrations/patient'
          end
        end
  end

  get '/login/patient' do
    erb :'patients/login/patient'
  end

  post '/login/patient' do
    @patient = Patient.find_by(email: params[:email])
      if @patient && @patient.authenticate(params[:password])
        session[:patient_id] = @patient.id
        redirect '/profile/patient'
      else
        flash.next[:message] = "Wrong email or password!"
        redirect '/login/patient'
      end
    end

  get '/profile/patient' do
    if ApplicationController.is_logged_in?(session)
      @patient = ApplicationController.current_user(session)
      erb :'patients/profile'
    else
      erb :welcome
    end
  end

  get '/back/patient' do
    if ApplicationController.is_logged_in?(session)
      if ApplicationController.current_user(session).class.name != "Doctor"
        redirect '/profile/patient'
      else
        redirect '/profile/doctor'
      end
    else
      redirect '/'
    end
  end

  get '/home/patient' do
    erb :'patients/home/patient'
  end
end
