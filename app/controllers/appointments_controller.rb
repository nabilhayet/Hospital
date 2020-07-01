class AppointmentsController < ApplicationController


  get '/appointment' do
    @doctor = Doctor.all
    if ApplicationController.is_logged_in?(session)
      @patient = ApplicationController.current_user(session)
      erb :'appointments/new'
    else
      erb :'/profile/patient'
    end
  end

  post '/appointments' do
    @patient = ApplicationController.current_user(session)
    if @patient
       if !params["patient"]["doctor_ids"].empty?
            @doctor = Doctor.find_by_id(params[:patient][:doctor_ids])
            @patient.doctors << @doctor 
            redirect "/appointment/#{@patient.id}"
       end
   else
     erb :'/appointments/show'
   end
  end

 get '/appointment/:id' do
   @patient = Patient.find_by_id(params[:id])
   erb :'/appointments/show'
 end


end
