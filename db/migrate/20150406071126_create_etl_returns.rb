class CreateEtlReturns < ActiveRecord::Migration
  def change
    create_table :etl_returns do |t|
      t.integer :member_plan_id
      t.date :issue_date
      t.date :return_date
      t.integer :rent_duration
      t.integer :issue_branch_id

      t.timestamps
    end
  end
end
