class DoctorsController < ApplicationController

  get '/registrations/doctor' do
    erb :'doctors/registration/doctor'
  end

  post '/registration/doctor' do
    @doctor = Doctor.find_by(email: params["email"])
      if @doctor
        flash.next[:message] = "Email address already exists."
        redirect '/registrations/doctor'
      else
        @doctor = Doctor.new(name: params["name"], email: params["email"], password: params["password"])
        if @doctor.save
          flash.next[:message] = "Successfully registered."
          session[:doctor_id] = @doctor.id
          redirect '/profile/doctor'
        else
          flash.next[:message] = "Please fill out form correctly!"
          redirect '/registrations/doctors'
        end
      end
  end

  get '/login/doctor' do
    erb :'doctors/login/doctor'
  end

  post '/login/doctor' do
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
    if is_logged_in?
      @doctor = current_user
      erb :'doctors/profile'
    else
      erb :welcome
    end
  end

  get '/back/doctor' do
    if is_logged_in?
      if current_user_type != "Patient"
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
