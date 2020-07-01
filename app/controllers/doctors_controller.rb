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
      @doctor.save
      flash.next[:message] = "Successfully registered."
      session[:doctor_id] = @doctor.id
      redirect '/home/doctor'
    end
  end

  get '/login/doctor' do
    erb :'/doctors/login/doctor'
  end

  post '/logins' do
    @doctor = Doctor.find_by(email: params[:email])
    if @doctor && @doctor.authenticate(params[:password])
      session[:doctor_id] = @doctor.id
      redirect '/profile/doctor'
    end
    redirect '/login/doctor'
  end

  get '/profile/doctor' do
    erb :'/doctors/show'
  end

  get '/sessionss/logout' do
    session.clear
    erb :'/doctors/home/doctor'
  end

  get '/home/doctor' do
    erb :'/doctors/home/doctor'
  end



end
