class CreateEtlCategories < ActiveRecord::Migration
  def change
    create_table :etl_categories do |t|
      t.string :name
      t.string :category_type
    end
  end
end
