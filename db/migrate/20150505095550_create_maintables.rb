class CreateMaintables < ActiveRecord::Migration
  def change
    create_table :maintables do |t|
      t.integer :report_id
      t.string :table

      t.timestamps
    end
  end
end
