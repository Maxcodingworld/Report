class CreateMemReports < ActiveRecord::Migration
  def change
    create_table :mem_reports do |t|
      t.integer :branch_id
      t.integer :plan_id
      t.integer :to_book
      t.integer :from_book
      t.date :to_date
      t.date :from_date
      t.string :day_limit

      t.timestamps
    end
  end
end
