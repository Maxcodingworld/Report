class CreateEtlTitles < ActiveRecord::Migration

  def change
    create_table :etl_titles, :force => true do |t|
      t.string :title
      t.integer :author_id
      t.integer :category_id
    end
  end
  
end