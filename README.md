1.Project title : The name of this project is Hospital. This project lets a patient or a doctor to sign-up and log-in. After logged in, a patient can make an appointment on a particular date at a fixed time by selecting an existing doctor in the system.
A doctor can also log into the system and view the existing appointments. Updating or deleting an appointment option available
to both doctor and patients.

2.Motivation : This project was created to provide a platform which will allow both doctor and patient to perform any task
on a common platform. Instead of creating two separate application for both, i decided to build something that would connect the both classes.

3.Tech/framework used Built with 1.Ruby 2.HTML 3.CSS 4.SQL

Features --A patient can sign-up. --A patient can log-in. --A patient can make an appointment. --Display details of the appointment for a particular patient. --Display a single appointment of a patient. --Update an appointment for a particular patient. --Delete an appointment for a particular patient. --A doctor can sign-up. --A doctor can log-in. --Display details of the appointment for a particular doctor. --Display a single appointment of a doctor. --Update an appointment for a particular doctor. --Delete an appointment for a particular doctor.

4. Code Example For this project, activerecord, sinatra, sqlite3, rake, shotgun, bcrypt, tux, sinatra-flash gems were used.

5. Code Snippet :

class ApplicationController < Sinatra::Base
  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions unless test?
    set :session_secret, "secret"
    register Sinatra::Flash
  end
  get "/" do
    erb :welcome
  end
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

 get '/view' do
  if ApplicationController.current_user(session).class.name != "Doctor"
   if ApplicationController.is_logged_in?(session)
       @patient = ApplicationController.current_user(session)
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
   redirect '/'
 end
 end

6. Installation -- https://github.com/nabilhayet/Hospital.git

7. Reference  
-- https://learn.co/tracks/online-software-engineering-structured/sinatra/activerecord/secure-password-lab
-- https://learn.co/tracks/online-software-engineering-structured/sinatra/activerecord/sinatra-restful-routes
-- https://learn.co/tracks/online-software-engineering-structured/sinatra/activerecord/activerecord-associations-join-tables

8. Tests -- Type 'shotgun' -- To sign-up as doctor click on Doctor link. -- To sign-up as patient click on Patient link. -- To go to the view from click on 'view all appointments'. -- To update an appointment click on 'update all appointments'. -- To delete any particular appointment click on 'delete an appointments'.

9. Credits -- https://learn.co/tracks/online-software-engineering-structured/sinatra/activerecord/sinatra-complex-forms-associations
