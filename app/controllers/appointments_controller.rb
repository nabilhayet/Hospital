class AppointmentsController < ApplicationController

  get '/appointment' do
  @doctor = Doctor.all

  erb :'appointments/new'
end

post '/appointments' do
    self.current_user
    redirect "appointments/#{@appointment.id}"
  end

  get '/appointments/:id' do

  end


end
