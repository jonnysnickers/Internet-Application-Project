class Appointment < ActiveRecord::Base
  
  belongs_to :patient, class_name: "User"
  belongs_to :doctor, class_name: "User"
  belongs_to :clinic
  
  validates :patient_id, :uniqueness => { :scope => :date }
  validates :doctor_id, :uniqueness => { :scope => :date }
  
  
end
