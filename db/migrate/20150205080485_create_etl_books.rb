class CreateEtlBooks < ActiveRecord::Migration

  def change
    create_table :etl_books, :force => true do |t|
          
        t.string   :state
              
    end
  end
  
end
