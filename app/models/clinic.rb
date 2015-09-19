class Clinic < ActiveRecord::Base
  
  has_many :duty, :dependent => :delete_all
  has_many :appointment, :dependent => :delete_all
  has_many :doc_cli
  
  validates :name, presence: true
  
end
