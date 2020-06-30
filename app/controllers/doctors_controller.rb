class DoctorsController < ApplicationController

  configure do
    enable :sessions unless test?
    set :session_secret, "secret"
  end

  

end
