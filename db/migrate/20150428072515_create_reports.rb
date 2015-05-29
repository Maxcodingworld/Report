class CreateReports < ActiveRecord::Migration
  def change
    create_table :reports do |t|
      t.string :description
      t.integer :invoke_times

      t.timestamps
    end
  end
end
