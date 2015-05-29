class AddTable < ActiveRecord::Migration
  def change
        
         create_table :jobs do |t|
            t.column :control_file, :string, :null => false
            t.column :created_at, :datetime, :null => false
            t.column :completed_at, :datetime
            t.column :status, :string
          end
          create_table :records do |t|
            t.column :control_file, :string, :null => false
            t.column :natural_key, :string, :null => false
            t.column :crc, :string, :null => false
            t.column :job_id, :integer, :null => false
          end
        
        
        
          add_index :records, :control_file
          add_index :records, :natural_key
          add_index :records, :job_id
        
        
          create_table :batches do |t|
            t.column :batch_file, :string, :null => false
            t.column :created_at, :datetime, :null => false
            t.column :completed_at, :datetime
            t.column :status, :string
          end
          add_column :jobs, :batch_id, :integer
          add_index :jobs, :batch_id
        
   
          add_column :batches, :batch_id, :integer
          add_index :batches, :batch_id
      
        # Update the schema info table, setting the version value
      
  end 
end
