![GitHub Repo stars](https://img.shields.io/github/stars/nabilhayet/Restaurant) ![GitHub forks](https://img.shields.io/github/forks/nabilhayet/Restaurant) ![GitHub followers](https://img.shields.io/github/followers/nabilhayet) ![Bitbucket open issues](https://img.shields.io/bitbucket/issues/nabilhayet/Restaurant)                                          
                                        <h1>:bomb: Hospital :bomb: </h1>
                                                      
The name of this project is. This project lets a patient or a doctor sign-up and log-in. After logged in, a patient can make an appointment on a particular date at a fixed time by selecting an existing doctor in the system. A doctor can also log into the system and view the existing appointments. Updating or deleting an appointment option available to both doctor and patients.

<p>This project was created to provide a platform that will allow both doctor and patient to perform any task on a common platform. Instead of creating two separate applications for both, I decided to build something that would connect both classes.</p>

<a href="https://www.youtube.com/watch?v=UWaRqHpO8fU&t=2s">Demo</a>

Table of Contents
- [Features](#features)
- [Tech-Stack](#tech-stack)
- [Installing](#installing)
- [Challenges](#challenges)
- [Future-Implementation](#future-implementation)
- [Code-Snippet](#code-snippet)
                               
## Features
<ul>
  <li>Sign in/Sign up option for users and doctors</li>
  <li>Full CRUD capabilities for users such as</li>
  <li>Make a new appointment</li>
  <li>View all existing appointments on this application</li>
  <li>Edit/Delete only the appointments make by the logged in user</li>
  <li>Full CRUD capabilities for doctors except create such as</li>
  <li>View all existing appointments on this application</li>
  <li>Edit/Delete only the appointments added by the logged in users</li>
</ul>

## Patient Signup
![patient_signup](https://user-images.githubusercontent.com/33500404/109451153-c7843200-7a1a-11eb-8b48-f0f60eb2d7c5.gif)

## Make Appointment 
![make_apt](https://user-images.githubusercontent.com/33500404/109450955-4167eb80-7a1a-11eb-822f-bd2304fed853.gif)

## View Appointments
![view_apt](https://user-images.githubusercontent.com/33500404/109451526-9eb06c80-7a1b-11eb-98db-abcb5fd8cb53.gif)

## Update Appointment
![update_apt](https://user-images.githubusercontent.com/33500404/109450657-69a31a80-7a19-11eb-9c4f-404457be3cbe.gif)

## Delete Appointment
![delete_pat_apt](https://user-images.githubusercontent.com/33500404/109451970-ae7c8080-7a1c-11eb-89d6-b92801d596b0.gif)

## Doctor Signin
![doctor_login](https://user-images.githubusercontent.com/33500404/109450502-05805680-7a19-11eb-90f2-0b78c6bad6fc.gif)

## Tech-Stack
<p>This web app makes use of the following:</p>

* sinatra
* activerecord, '~> 4.2', '>= 4.2.6', :require => active_record
* sinatra-activerecord, :require => sinatra/activerecord
* rake
* require_all
* sqlite3, '~> 1.3.6'
* thin
* shotgun
* pry
* bcrypt
* tux
* sinatra-flash

## Installing
<ul>
   <li> Clone this repo to your local machine git clone <this-repo-url></li>
   <li> run bundle install to install required dependencies</li>
   <li> run rails db:create to create a database locally.</li>
   <li> run rails db:migrate to create tables into the database.</li>
   <li> run rails db:seed to create seed data.</li>
   <li> Type 'shotgun'</li>
</ul>
        
## Challenges
<ul>
  <li> Preventing users from accessing other user's info</li>
  <li> Adding flash message</li>
  <li> Rafactor using helper methods</li>
  <li> Formatting date and time </li>
</ul>

## Future-Implementation
<ul>
  <li> Add more models like Prescription, tests etc</li>
  <li> Add Bootstrap for styling</li>
  <li> Add a range for the booking time</li>
</ul>

## Code-Snippet 

```
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
```

```
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
```

```
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
```




