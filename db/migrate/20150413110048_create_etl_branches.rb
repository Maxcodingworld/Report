class CreateEtlBranches < ActiveRecord::Migration
  def change
    create_table :etl_branches do |t|
      t.string :name
      t.string :category
    end
  end
end
