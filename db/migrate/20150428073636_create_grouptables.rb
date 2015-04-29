class CreateGrouptables < ActiveRecord::Migration
  def change
    create_table :grouptables do |t|
      t.integer :report_id
      t.string :table_attribute

      t.timestamps
    end
  end
end
