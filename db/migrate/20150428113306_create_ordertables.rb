class CreateOrdertables < ActiveRecord::Migration
  def change
    create_table :ordertables do |t|
      t.integer :report_id
      t.string :table_attribute
      t.string :desc_asce
      t.string :expo_default_flag

      t.timestamps
    end
  end
end
