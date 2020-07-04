class AppointmentsController < ApplicationController


  get '/appointment' do
    @doctor = Doctor.all
    if ApplicationController.is_logged_in?(session)
      @patient = ApplicationController.current_user(session)
      erb :'appointments/new'
    else
      redirect '/profile/patient'
    end
  end

  post '/appointments' do
    @patient = ApplicationController.current_user(session)
    @appointment = Appointment.all.select{|apt| apt.time==params[:time] && apt.date==params[:date] && (apt.patient.id==@patient.id || apt.doctor.id==params[:patient][:doctor_ids])}

    if @patient
      if @appointment.empty?
            @doctor = Doctor.find_by_id(params[:patient][:doctor_ids])
            @apt = Appointment.create(doctor_id: params[:patient][:doctor_ids], patient_id: @patient.id, date: params[:date],time: params[:time])
            redirect "/appointments/#{@apt.id}"
        end
   else
     erb :'/appointments/new'
   end
  end

 get '/appointments/:id' do
  if ApplicationController.is_logged_in?(session)
    @apt = Appointment.find_by_id(params[:id])
    erb :'/appointments/show'
  else
    redirect '/appointment'
  end
end

get '/view' do
  if ApplicationController.is_logged_in?(session)
    @patient = ApplicationController.current_user(session)
    @apt = @patient.appointments
      if @apt
        erb :'/appointments/view'
      end
  else
    flash.now[:message] = "You have no appointment"
    redirect 'profile/patient'
  end
end

get '/update' do
  if ApplicationController.is_logged_in?(session)
    @patient = ApplicationController.current_user(session)
    @apt = @patient.appointments
      if !@apt.empty?
        erb :'/appointments/update'
      end
  else
      flash.now[:message] = "You have no appointmen to updatet"
      redirect 'profile/patient'
  end
end

get '/appointments/:id/edit' do
  if ApplicationController.is_logged_in?(session)
      @patient = ApplicationController.current_user(session)
      @apt = Appointment.find_by_id(params[:id])
    if @apt.patient_id==@patient.id
       @doctor = Doctor.all
      erb :'/appointments/edit'
    else
      erb :'/patients/new'
    end
else
    redirect 'profile/patient'
  end
end

patch '/appointments/:id' do
  @patient = ApplicationController.current_user(session)
  @appointment = Appointment.find_by_id(params[:id])
  apt.time==params[:time] && apt.date==params[:date] && (apt.patient.id==@patient.id || apt.doctor.id==params[:patient][:doctor_ids]
  if @patient
    if @appointment.empty?
          @doctor = Doctor.find_by_id(params[:patient][:doctor_ids])
          @apt = Appointment.create(doctor_id: params[:patient][:doctor_ids], patient_id: @patient.id, date: params[:date],time: params[:time])
          redirect "/appointments/#{@apt.id}"
      end
 else
   erb :'/appointments/new'
 end
end

end
