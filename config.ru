require './config/environment'
require_relative 'app/controllers/doctors_controller'
require_relative 'app/controllers/patients_controller'
require_relative 'app/controllers/appointments_controller'



if ActiveRecord::Migrator.needs_migration?
  raise 'Migrations are pending. Run `rake db:migrate` to resolve the issue.'
end

use Rack::MethodOverride


use DoctorsController
use PatientsController
use AppointmentsController

run ApplicationController
