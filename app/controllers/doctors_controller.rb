class DoctorsController < ApplicationController

  get '/registrations/doctor' do
    erb :'doctors/registration/doctor'
  end

  post '/registrationss' do
    @doctor = Doctor.find_by(email: params["email"])
      if @doctor
        flash.next[:message] = "Email address already exists."
        redirect '/registrations/doctor'
      else
        @doctor = Doctor.new(name: params["name"], email: params["email"], password: params["password"])
        if @doctor.save
          flash.next[:message] = "Successfully registered."
          session[:doctor_id] = @doctor.id
          redirect '/home/doctor'
        else
          flash.next[:message] = "Please fill out form correctly!"
          redirect 'registrations/doctors'
        end
      end
  end

  get '/login/doctor' do
    erb :'doctors/login/doctor'
  end

  post '/logins' do
    @doctor = Doctor.find_by(email: params[:email])
      if @doctor && @doctor.authenticate(params[:password])
        session[:doctor_id] = @doctor.id
        redirect '/profile/doctor'
      else
        flash.next[:message] = "Wrong email or password!"
        redirect '/login/doctor'
      end

  end

  get '/profile/doctor' do
    if ApplicationController.is_logged_in?(session)
      @doctor = ApplicationController.current_user(session)
      erb :'doctors/profile'
    else
      erb :welcome
    end
  end

  get '/back/doctor'
    if ApplicationController.is_logged_in?(session)
      if ApplicationController.current_user(session).class.name != "Patient"
        redirect '/profile/doctor'
      else
        redirect '/profile/patient'
      end
    else
      redirect '/'
    end
  end

  get '/home/doctor' do
    erb :'doctors/home/doctor'
  end
end
