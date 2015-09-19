class User < ActiveRecord::Base
  
  has_many :duty, :dependent => :delete_all
  has_many :appointment, foreign_key: "doctor_id", :dependent => :delete_all
  has_many :appointment, foreign_key: "patient_id", :dependent => :delete_all
  has_many :doc_cli
  
  validates :firstname, presence: true, length: { maximum: 50 }
  validates :lastname, presence: true, length: { maximum: 50 }
  validates :pesel, presence: true
  validates :address, presence: true
  validates :username, presence: true, uniqueness: { case_sensitive: false }
      
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true
  validates :enabled, presence: true
  validates :ttype, presence: true
  
  has_secure_password
  
  
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end
  
end
