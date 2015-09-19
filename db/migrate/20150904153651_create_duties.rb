class CreateDuties < ActiveRecord::Migration
  def change
    create_table :duties do |t|

      t.integer :user_id
      t.integer :clinic_id
      t.integer :date

      t.timestamps null: false
    end
    
    add_index :duties, [:user_id, :date], :unique => true
    
  end
end
