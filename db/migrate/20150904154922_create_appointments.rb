class CreateAppointments < ActiveRecord::Migration
  def change
    create_table :appointments do |t|
      
      t.integer :patient_id
      t.integer :doctor_id
      t.integer :clinic_id
      t.string  :enabled
      t.timestamp :date

      t.timestamps null: false
    end
    
    add_index :appointments, [:patient_id, :date], :unique => true
    add_index :appointments, [:doctor_id, :date], :unique => true
    
  end
end
