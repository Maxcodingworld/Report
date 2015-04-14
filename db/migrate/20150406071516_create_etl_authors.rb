class CreateEtlAuthors < ActiveRecord::Migration
  def change
    create_table :etl_authors do |t|
      t.string :name
    end
  end
end
