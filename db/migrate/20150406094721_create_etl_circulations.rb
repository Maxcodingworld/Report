class CreateEtlCirculations < ActiveRecord::Migration
  def change
    create_table :etl_circulations do |t|
      t.integer :member_plan_id
      t.integer :title_id
      t.date :issue_date
      t.date :return_date
      t.integer :rent_duration
      t.integer :issue_branch_id
      t.integer :created_at_in_second
      t.integer :updated_at_in_second
      t.integer :author_id
      t.string :category_type
      t.string :category_name

      t.timestamps
    end
  end
end
