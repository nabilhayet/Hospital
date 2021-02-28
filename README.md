![GitHub Repo stars](https://img.shields.io/github/stars/nabilhayet/Restaurant) ![GitHub forks](https://img.shields.io/github/forks/nabilhayet/Restaurant) ![GitHub followers](https://img.shields.io/github/followers/nabilhayet) ![Bitbucket open issues](https://img.shields.io/bitbucket/issues/nabilhayet/Restaurant)                                          
                                        <h1>:bomb: Hospital :bomb: </h1>
                                                      
The name of this project is . This project lets a patient or a doctor to sign-up and log-in. After logged in, a patient can make an appointment on a particular date at a fixed time by selecting an existing doctor in the system. A doctor can also log into the system and view the existing appointments. Updating or deleting an appointment option available to both doctor and patients.

<p>This project was created to provide a platform which will allow both doctor and patient to perform any task on a common platform. Instead of creating two separate application for both, i decided to build something that would connect the both classes.</p>

<a href="https://www.youtube.com/watch?v=UWaRqHpO8fU&t=2s">Demo</a>

Table of Contents
- [Features](#features)
- [Tech-Stack](#tech-stack)
- [Installing](#installing)
- [Challenges](#challenges)
- [Future-Implementation](#future-implementation)
- [Code-Snippet](#code-snippet)
- [Tests](#tests)
                               
## Features
<ul>
 A patient can sign-up. --A patient can log-in. --A patient can make an appointment. --Display details of the appointment for a particular patient. --Display a single appointment of a patient. --Update an appointment for a particular patient. --Delete an appointment for a particular patient. --A doctor can sign-up. --A doctor can log-in. --Display details of the appointment for a particular doctor. --Display a single appointment of a doctor. --Update an appointment for a particular doctor. --Delete an appointment for a particular doctor.
</ul>

## Signup 

![dem](https://user-images.githubusercontent.com/33500404/109376302-97f5ee00-7891-11eb-89aa-6fdfd054c8c9.gif)


## Tech-Stack
<p>This web app makes use of the following:</p>

* pry
* nokogiri 

## Installing
<ul>
   <li> Clone this repo to your local machine git clone <this-repo-url></li>
   <li> Type 'shotgun'</li>
  
</ul>
        
## Challenges
<ul>
  <li> Scrapping was the most difficult task of this project</li>
  <li> After fething data from the website, filtering out perticular info was also challenging</li>
  <li> Loading so much data took a lot of time to run the application</li>
</ul>

## Future-Implementation
<ul>
  <li> Add more classes like Editor</li>
  <li> Remove duplicacy of code</li>
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




