class Patient < ActiveRecord::Base
  has_secure_password
  validates_presence_of :name, :email, :password
  has_many :appointments
  has_many :doctors, through: :appointments
end
