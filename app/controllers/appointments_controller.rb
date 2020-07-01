class AppointmentsController < ApplicationController


  get '/appointment' do
    @doctor = Doctor.all
    if ApplicationController.is_logged_in?(session)
      @patient = ApplicationController.current_user(session)
      erb :'appointments/new'
    else
      erb :'/patients/new'
    end
  end

  post '/appointments' do
    @patient = ApplicationController.current_user(session)
    if @patient
     erb :'/appointments/edit'
   else
     erb :'/appointments/show'
   end
  end



end
