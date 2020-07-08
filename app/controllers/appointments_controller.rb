class AppointmentsController < ApplicationController

  get '/appointment' do
    @doctor = Doctor.all
      if ApplicationController.is_logged_in?(session)
        @patient = ApplicationController.current_user(session)
        erb :'appointments/patient/new'
      else
        redirect '/profile/patient'
      end
  end

  post '/appointments' do
    @patient = ApplicationController.current_user(session)
    @appointment = Appointment.all.select do |apt|
      (apt.time.strftime("%H:%M") == params[:time] && apt.date.to_s == params[:date]) && (apt.patient.id == @patient.id || apt.doctor.id == params[:patient][:doctor_ids])
    end
      if @patient
        if @appointment.empty?
          @doctor = Doctor.find_by_id(params[:patient][:doctor_ids])
          @apt = Appointment.create(doctor_id: params[:patient][:doctor_ids], patient_id: @patient.id, date: params[:date],time: params[:time])
          flash.next[:message] = "Appointment was created Successfully"
          redirect "/appointments/#{@apt.id}"
        else
          flash.next[:message] = "Appointment was not created Successfully"
          redirect '/profile/patient'
        end
      else
        redirect '/'
      end
  end

  get '/appointments/:id' do
    if ApplicationController.is_logged_in?(session)
        @patient = ApplicationController.current_user(session)
        @apt = Appointment.find_by_id(params[:id])
          if @apt!=nil && @patient.id == @apt.patient_id
              erb :'appointments/patient/show'
          else
            flash.next[:message] = "No such appointment exists!"
            redirect '/profile/patient'
          end
    else
      redirect '/'
    end
  end

  get '/view' do
    if ApplicationController.is_logged_in?(session)
        @patient = ApplicationController.current_user(session)
        @apt = @patient.appointments
          if !@apt.empty?
            erb :'appointments/patient/view'
          else
            flash.next[:message] = "You have no appointment to view"
            redirect '/profile/patient'
          end
    else
      redirect '/'
    end
  end

  get '/update' do
    if ApplicationController.is_logged_in?(session)
        @patient = ApplicationController.current_user(session)
        @apt = @patient.appointments
          if !@apt.empty?
            erb :'appointments/patient/update'
          else
            flash.next[:message] = "You have no appointment to update"
            redirect '/profile/patient'
          end
    else
      redirect '/'
    end
  end

  get '/appointments/:id/edit' do
    if ApplicationController.is_logged_in?(session)
        @patient = ApplicationController.current_user(session)
        @apt = Appointment.find_by_id(params[:id])
          if @apt!=nil && @apt.patient_id == @patient.id
             @doctor = Doctor.all
             erb :'appointments/patient/edit'
          else
            flash.next[:message] = "You have no appointment to update of this number"
            redirect '/profile/patient'
          end
    else
     redirect '/'
    end
  end

  patch '/appointments/:id' do
    @patient = ApplicationController.current_user(session)
    @apt = Appointment.find_by_id(params[:id])
    @appointment = Appointment.find{|apt| apt.time.strftime("%H:%M")==params[:time] && apt.date.to_s==params[:date] && (apt.patient.id==@patient.id || apt.doctor.id==params[:doctor_id])}

      if !@appointment
        @apt.doctor_id = params[:doctor_id]
        @apt.patient_id = @patient.id
        @apt.time = params[:time]
        @apt.date = params[:date]
        @apt.save
        flash.next[:message] = "Appointment was updated Successfully"
        redirect "/appointments/#{@apt.id}"
      else
        flash.next[:message] = "You can not update this appointment!"
        redirect '/profile/patient'
      end
  end

  get '/delete' do
    if ApplicationController.is_logged_in?(session)
      @patient = ApplicationController.current_user(session)
      @apt = @patient.appointments
        if !@apt.empty?
          erb :'appointments/patient/remove'
        else
          flash.next[:message] = "You have no appointment to delete"
          redirect '/profile/patient'
        end
    else
      redirect '/'
    end
  end

  get '/appointments/:id/delete' do
    if ApplicationController.is_logged_in?(session)
      @patient = ApplicationController.current_user(session)
      @apt = Appointment.find_by_id(params[:id])
        if @apt!=nil && @apt.patient_id == @patient.id
           erb :'appointments/patient/delete'
        else
          flash.next[:message] = "You have no appointment to delete"
          redirect '/profile/patient'
        end
    else
      redirect '/'
    end
  end

  delete '/appointments/:id' do
    @apt = Appointment.find_by_id(params[:id])
    @apt.delete
    flash.next[:message] = "Appointment was deleted Successfully!"
    redirect '/view'
  end

  get '/appointmentss/:id' do
    if ApplicationController.is_logged_in?(session)
      @doctor = ApplicationController.current_user(session)
      @apt = Appointment.find_by_id(params[:id])

        if @apt!=nil && @doctor.id == @apt.doctor_id
          erb :'appointments/doctor/shows'
        else
          flash.next[:message] = "You don't have permission to view this!"
          redirect '/profile/doctor'
        end
    else
      redirect '/'
    end
  end

  get '/view/doctor' do
    if ApplicationController.is_logged_in?(session)

      @doctor = ApplicationController.current_user(session)
      @apt = @doctor.appointments
        if !@apt.empty?
          erb :'appointments/doctor/views'
        else
          flash.next[:message] = "You have no appointment to view"
          redirect '/profile/doctor'
        end
   else
     redirect '/'
   end
 end

 get '/update/doctor' do
   if ApplicationController.is_logged_in?(session)
     @doctor = ApplicationController.current_user(session)
     @apt = @doctor.appointments
        if !@apt.empty?
          erb :'appointments/doctor/updates'
        else
          flash.next[:message] = "You have no appointment to update"
          redirect '/profile/doctor'
        end
   else
    redirect '/'
  end
end

  get '/appointmentss/:id/edit' do
    if ApplicationController.is_logged_in?(session)
      @doctor = ApplicationController.current_user(session)
      @apt = Appointment.find_by_id(params[:id])
        if @apt!=nil && @apt.doctor_id==@doctor.id
           @doctor = Doctor.all
           erb :'appointments/doctor/edits'
        else
          flash.next[:message] = "You have no appointment to update of this number"
          redirect '/profile/doctor'
        end
    else
      redirect '/'
    end
  end

  patch '/appointmentss/:id' do
    @doctor = ApplicationController.current_user(session)
    @apt = Appointment.find_by_id(params[:id])
    @patient = @apt.patient
    @appointment = Appointment.select{|apt| apt.time.strftime("%H:%M")==params[:time] && apt.date.to_s==params[:date] && (apt.patient.id==@patient.id || apt.doctor.id==@doctor.id)}

      if @appointment.empty?
        @apt.time = params[:time]
        @apt.date = params[:date]
        @apt.save
        flash.next[:message] = "Appointment was updated Successfully!"
        redirect "/appointmentss/#{@apt.id}"
      else
        flash.now[:message] = "You can not update this appointment"
        erb :'appointments/doctor/updates'
      end
  end

  get '/delete/doctor' do
    if ApplicationController.is_logged_in?(session)
      @doctor = ApplicationController.current_user(session)
      @apt = @doctor.appointments
        if !@apt.empty?
          erb :'appointments/doctor/removes'
        else
          flash.next[:message] = "You have no appointment to delete"
          redirect '/profile/doctor'
        end
    else
      redirect '/'
    end
  end

  get '/appointmentss/:id/delete' do
    if ApplicationController.is_logged_in?(session)
      @doctor = ApplicationController.current_user(session)
      @apt = Appointment.find_by_id(params[:id])
        if @apt!=nil && @apt.doctor_id == @doctor.id
          erb :'appointments/doctor/deletes'
        else
          flash.next[:message] = "You have no appointment to delete"
          redirect '/profile/doctor'
        end
    else
      redirect '/'
    end
  end

  delete '/appointmentss/:id' do
    @apt = Appointment.find_by_id(params[:id])
    @apt.delete
    flash.next[:message] = "Appointment was deleted Successfully!"
    redirect '/view/doctor'
  end
end
