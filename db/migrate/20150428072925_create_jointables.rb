class CreateJointables < ActiveRecord::Migration
  def change
    create_table :jointables do |t|
      t.integer :report_id
      t.string :table1
      t.string :table2
      t.string :whichjoin

      t.timestamps
    end
  end
end
