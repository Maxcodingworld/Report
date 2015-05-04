class CreateSelecttables < ActiveRecord::Migration
  def change
    create_table :selecttables do |t|
      t.integer :report_id
      t.string :table_attribute

      t.timestamps
    end
  end
end
