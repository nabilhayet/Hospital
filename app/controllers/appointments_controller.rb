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
    @appointment = Appointment.all.select{|apt| apt.time==params[:time] && apt.date==params[:date] && apt.id==@patient.id}

    if @patient
      if !@appointment
        if !params["patient"]["doctor_ids"].empty?
            @doctor = Doctor.find_by_id(params[:patient][:doctor_ids])
            @apt = Appointment.create(params[:patient][:doctor_ids],session[:patient_id],params[:date],params[:time])
            # @patient.doctors << @doctor
            # # @appt = Appointment.last
            # @appt.date = params[:date]
            # @appt.time = params[:time]
            redirect "/appointment/#{@apt.id}"
          end
       end
   else
     erb :'/appointments/new'
   end
  end

 get '/appointment/:id' do
  if ApplicationController.is_logged_in?(session)
    @patient = Patient.find_by_id(params[:id])
    @apt = Appointment.find_by_id(params[:id])
    erb :'/appointments/show'
  else
    redirect '/appointment'
  end
end

end
