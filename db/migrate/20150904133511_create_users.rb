class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      
      t.string :firstname
      t.string :lastname
      t.string :pesel
      t.string :address
      t.string :username
      
      t.string :password_digest
      t.string :enabled
      t.string :ttype
      
      t.timestamps null: false
    end
  end
end
