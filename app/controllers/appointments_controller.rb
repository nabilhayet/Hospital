class AppointmentsController < ApplicationController

  get '/patient/appointments/new' do
   if current_user_type != "Doctor"
    @doctor = Doctor.all
      if is_logged_in?
        @patient = current_user
        erb :'appointments/patient/new'
      else
        redirect '/profile/patient'
      end
    else
      redirect '/profile/doctor'
    end
  end

  post '/patient/appointments' do
    @patient = current_user
    @appointment = Appointment.all.select do |apt|
      (apt.time.strftime("%H:%M") == params[:time] && apt.date.to_s == params[:date]) && (apt.patient.id == @patient.id || apt.doctor.id == params[:patient][:doctor_ids])
    end
      if @patient
        if @appointment.empty?
          @doctor = Doctor.find_by_id(params[:patient][:doctor_ids])
          @apt = Appointment.create(doctor_id: params[:patient][:doctor_ids], patient_id: @patient.id, date: params[:date],time: params[:time])
          flash.next[:message] = "Appointment was created Successfully"
          redirect "/patient/appointments/#{@apt.id}"
        else
          flash.next[:message] = "Appointment was not created Successfully"
          redirect '/profile/patient'
        end
      else
        redirect '/'
      end
  end

  get '/patient/appointments/:id' do
   if current_user_type != "Doctor"
    if is_logged_in?
        @patient = current_user
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
  else
    redirect '/profile/doctor'
  end
  end

  get '/patient/appointments' do
   if current_user_type != "Doctor"
    if is_logged_in?
        @patient = current_user
        @apt = @patient.appointments
          if !@apt.empty?
            erb :'appointments/patient/index'
          else
            flash.next[:message] = "You have no appointment to view"
            redirect '/profile/patient'
          end
    else
      redirect '/'
    end
  else
    redirect '/profile/doctor'
  end
  end

  get '/patient/appointments/:id/edit' do
   if current_user_type != "Doctor"
    if is_logged_in?
        @patient = current_user
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
  else
    redirect '/profile/doctor'
  end
  end

  patch '/patient/appointments/:id' do
    @patient = current_user
    @apt = Appointment.find_by_id(params[:id])
    @appointment = Appointment.find{|apt| apt.time.strftime("%H:%M")==params[:time] && apt.date.to_s==params[:date] && (apt.patient.id==@patient.id || apt.doctor.id==params[:doctor_id])}

      if !@appointment
        @apt.doctor_id = params[:doctor_id]
        @apt.patient_id = @patient.id
        @apt.time = params[:time]
        @apt.date = params[:date]
        @apt.save
        flash.next[:message] = "Appointment was updated Successfully"
        redirect "/patient/appointments/#{@apt.id}"
      else
        flash.next[:message] = "You can not update this appointment!"
        redirect '/profile/patient'
      end
  end

  get '/patient/appointments/:id/delete' do
   if current_user_type != "Doctor"
    if is_logged_in?
      @patient = current_user
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
  else
    redirect '/profile/doctor'
  end
  end

  delete '/patient/appointments/:id' do
    if current_user_type != "Doctor"
     if is_logged_in?
       @patient = current_user
       @apt = Appointment.find_by_id(params[:id])
       if @apt.patient_id == @patient.id
         @apt.delete
         flash.next[:message] = "Appointment was deleted Successfully!"
         redirect '/profile/patient'
      else
        flash.next[:message] = "You have no appointment to delete"
        redirect '/profile/patient'
      end
    else
        redirect '/'
    end
  else
    redirect '/profile/doctor'
  end
  end

  get '/doctor/appointments/:id' do
   if current_user_type != "Patient"
    if is_logged_in?
      @doctor = current_user
      @apt = Appointment.find_by_id(params[:id])

        if @apt!=nil && @doctor.id == @apt.doctor_id
          erb :'appointments/doctor/show'
        else
          flash.next[:message] = "You don't have permission to view this!"
          redirect '/profile/doctor'
        end
    else
      redirect '/'
    end
  else
    redirect '/profile/patient'
  end
  end

  get '/doctor/appointments' do
   if current_user_type != "Patient"
    if is_logged_in?
      @doctor = current_user
      @apt = @doctor.appointments
        if !@apt.empty?
          erb :'appointments/doctor/index'
        else
          flash.next[:message] = "You have no appointment to view"
          redirect '/profile/doctor'
        end
   else
     redirect '/'
   end
 else
   redirect '/profile/patient'
 end
 end

 get '/doctor/appointments/:id/edit' do
   if current_user_type != "Patient"
    if is_logged_in?
      @doctor = current_user
      @apt = Appointment.find_by_id(params[:id])
        if @apt!=nil && @apt.doctor_id==@doctor.id
           @doctor = Doctor.all
           erb :'appointments/doctor/edit'
        else
          flash.next[:message] = "You have no appointment to update of this number"
          redirect '/profile/doctor'
        end
    else
      redirect '/'
    end
  else
    redirect '/profile/patient'
  end
  end

  patch '/doctor/appointments/:id' do
    @doctor = current_user
    @apt = Appointment.find_by_id(params[:id])
    @patient = @apt.patient
    @appointment = Appointment.select{|apt| apt.time.strftime("%H:%M")==params[:time] && apt.date.to_s==params[:date] && (apt.patient.id==@patient.id || apt.doctor.id==@doctor.id)}

      if @appointment.empty?
        @apt.time = params[:time]
        @apt.date = params[:date]
        @apt.save
        flash.next[:message] = "Appointment was updated Successfully!"
        redirect "/doctor/appointments/#{@apt.id}"
      else
        flash.now[:message] = "You can not update this appointment"
        erb :'appointments/doctor/edit'
      end
  end

  get '/doctor/appointments/:id/delete' do
   if current_user_type != "Patient"
    if is_logged_in?
      @doctor = current_user
      @apt = Appointment.find_by_id(params[:id])
        if @apt!=nil && @apt.doctor_id == @doctor.id
          erb :'appointments/doctor/delete'
        else
          flash.next[:message] = "You have no appointment to delete"
          redirect '/profile/doctor'
        end
    else
      redirect '/'
    end
  else
    redirect '/profile/patient'
  end
  end

  delete '/doctor/appointments/:id' do
    if current_user_type != "Patient"
     if is_logged_in?
       @doctor = current_user
       @apt = Appointment.find_by_id(params[:id])
       if @apt.doctor_id == @doctor.id
         @apt.delete
         flash.next[:message] = "Appointment was deleted Successfully!"
         redirect '/profile/doctor'
      else
        flash.next[:message] = "You have no appointment to delete"
        redirect '/profile/doctor'
      end
    else
        redirect '/'
    end
    else
    redirect '/profile/patient'
    end
end
