class CreateDocClis < ActiveRecord::Migration
  def change
    create_table :doc_clis do |t|

      t.integer :user_id
      t.integer :clinic_id

      t.timestamps null: false
    end
    
    add_index :doc_clis, [:user_id, :clinic_id], :unique => true
    
  end
end
