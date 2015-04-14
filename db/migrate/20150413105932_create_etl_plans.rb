class CreateEtlPlans < ActiveRecord::Migration
  def change
    create_table :etl_plans do |t|
      t.string :name
    end
  end
end
