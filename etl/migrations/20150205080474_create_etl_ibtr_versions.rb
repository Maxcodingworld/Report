class CreateEtlIbtrVersions < ActiveRecord::Migration

  def change
    create_table :etl_ibtr_versions, :force => true do |t|
        t.integer :ibtr_id  
        t.string  :state
        t.integer :created_by
        t.integer :created_at_int 
        t.integer :updated_at_int
        t.string  :flag_destination
        t.integer :book_id
        t.datetime :created_at_date
        t.datetime :updated_at_date 
    end
  end
  
end
