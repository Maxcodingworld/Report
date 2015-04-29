class CreateHavingtables < ActiveRecord::Migration
  def change
    create_table :havingtables do |t|
      t.integer :report_id
      t.string :table_attribute
      t.string :r_operator
      t.string :value
      t.string :expo_default_flag

      t.timestamps
    end
  end
end
