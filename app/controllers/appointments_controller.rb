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
    @appointment = Appointment.all.select{|apt| (apt.time == params[:time] && apt.date == params[:date]) && (apt.patient.id == @patient.id || apt.doctor.id == params[:patient][:doctor_ids])}

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
        erb :'welcome'
      end
  end

  get '/appointments/:id' do
    if ApplicationController.is_logged_in?(session)
        @patient = ApplicationController.current_user(session)
        @apt = Appointment.find_by_id(params[:id])
          if @apt!=nil && @patient.id == @apt.patient_id
              erb :'appointments/show'
          else
            flash.next[:message] = "No such appointment exists!"
            redirect '/profile/patient'
          end
    else
      erb :welcome
    end
  end

  get '/view' do
    if ApplicationController.is_logged_in?(session)
        @patient = ApplicationController.current_user(session)
        @apt = @patient.appointments
          if !@apt.empty?
            erb :'appointments/view'
          else
            flash.next[:message] = "You have no appointment to view"
            redirect '/profile/patient'
          end
    else
      erb :welcome
    end
  end

  get '/update' do
    if ApplicationController.is_logged_in?(session)
        @patient = ApplicationController.current_user(session)
        @apt = @patient.appointments
          if !@apt.empty?
            erb :'appointments/update'
          else
            flash.next[:message] = "You have no appointment to update"
            redirect '/profile/patient'
          end
    else
      erb :welcome
    end
  end

  get '/appointments/:id/edit' do
    if ApplicationController.is_logged_in?(session)
        @patient = ApplicationController.current_user(session)
        @apt = Appointment.find_by_id(params[:id])
          if @apt!=nil && @apt.patient_id == @patient.id
             @doctor = Doctor.all
             erb :'appointments/edit'
          else
            flash.next[:message] = "You have no appointment to update of this number"
            redirect '/profile/patient'
          end
    else
     erb :welcome
    end
  end

  patch '/appointments/:id' do
    @patient = ApplicationController.current_user(session)
    @apt = Appointment.find_by_id(params[:id])
    @appointment = Appointment.select{|apt| apt.time==params[:time] && apt.date==params[:date] && (apt.patient.id==@patient.id || apt.doctor.id==params[:doctor_id])}

      if @appointment.empty?
        @apt.doctor_id = params[:doctor_id]
        @apt.patient_id = @patient.id
        @apt.time = params[:time]
        @apt.date = params[:date]
        @apt.save
        flash.next[:message] = "Appointment was updated Successfully"
        redirect "/appointments/#{@apt.id}"
      else
        flash.now[:message] = "You can not update this appointment!"
        erb :'appointments/update'
      end
  end

  get '/delete' do
    if ApplicationController.is_logged_in?(session)
      @patient = ApplicationController.current_user(session)
      @apt = @patient.appointments
        if !@apt.empty?
          erb :'appointments/remove'
        else
          flash.next[:message] = "You have no appointment to delete"
          redirect '/profile/patient'
        end
    else
      erb :welcome
    end
  end

  get '/appointments/:id/delete' do
    if ApplicationController.is_logged_in?(session)
      @patient = ApplicationController.current_user(session)
      @apt = Appointment.find_by_id(params[:id])
        if @apt!=nil && @apt.patient_id == @patient.id
           erb :'appointments/delete'
        else
          flash.next[:message] = "You have no appointment to delete"
          redirect '/profile/patient'
        end
    else
      erb :welcome
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
          erb :'appointments/shows'
        else
          flash.next[:message] = "You don't have permission to view this!"
          redirect '/profile/doctor'
        end
    else
      erb :welcome
    end
  end

  get '/view/doctor' do
    if ApplicationController.is_logged_in?(session)
      @doctor = ApplicationController.current_user(session)
      @apt = @doctor.appointments
        if !@apt.empty?
          erb :'appointments/views'
        else
          flash.next[:message] = "You have no appointment to view"
          redirect '/profile/doctor'
        end
   else
     erb :welcome
   end
 end

 get '/update/doctor' do
   if ApplicationController.is_logged_in?(session)
     @doctor = ApplicationController.current_user(session)
     @apt = @doctor.appointments
        if !@apt.empty?
          erb :'appointments/updates'
        else
          flash.next[:message] = "You have no appointment to update"
          redirect '/profile/doctor'
        end
   else
    erb :welcome
  end
end

  get '/appointmentss/:id/edit' do
    if ApplicationController.is_logged_in?(session)
      @doctor = ApplicationController.current_user(session)
      @apt = Appointment.find_by_id(params[:id])
        if @apt!=nil && @apt.doctor_id==@doctor.id
           @doctor = Doctor.all
           erb :'appointments/edits'
        else
          flash.next[:message] = "You have no appointment to update of this number"
          redirect '/profile/doctor'
        end
    else
      erb :welcome
    end
  end

  patch '/appointmentss/:id' do
    @doctor = ApplicationController.current_user(session)
    @apt = Appointment.find_by_id(params[:id])
    @patient = @apt.patient
    @appointment = Appointment.select{|apt| apt.time==params[:time] && apt.date==params[:date] && (apt.patient.id==@patient.id || apt.doctor.id==@doctor.id)}

      if @appointment.empty?
        @apt.time = params[:time]
        @apt.date = params[:date]
        @apt.save
        flash.next[:message] = "Appointment was updated Successfully!"
        redirect "/appointmentss/#{@apt.id}"
      else
        flash.now[:message] = "You can not update this appointment"
        erb :'appointments/updates'
      end
  end

  get '/delete/doctor' do
    if ApplicationController.is_logged_in?(session)
      @doctor = ApplicationController.current_user(session)
      @apt = @doctor.appointments
        if !@apt.empty?
          erb :'appointments/removes'
        else
          flash.next[:message] = "You have no appointment to delete"
          redirect '/profile/doctor'
        end
    else
      erb :welcome
    end
  end

  get '/appointmentss/:id/delete' do
    if ApplicationController.is_logged_in?(session)
      @doctor = ApplicationController.current_user(session)
      @apt = Appointment.find_by_id(params[:id])
        if @apt!=nil && @apt.doctor_id == @doctor.id
          erb :'appointments/deletes'
        else
          flash.next[:message] = "You have no appointment to delete"
          redirect '/profile/doctor'
        end
    else
      erb :welcome
    end
  end

  delete '/appointmentss/:id' do
    @apt = Appointment.find_by_id(params[:id])
    @apt.delete
    flash.next[:message] = "Appointment was deleted Successfully!"
    redirect '/view/doctor'
  end
end
