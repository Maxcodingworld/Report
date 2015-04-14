class AddPlanIdToEtlCirculations < ActiveRecord::Migration
  def change
    add_column :etl_circulations, :plan_id, :integer
  end
end
