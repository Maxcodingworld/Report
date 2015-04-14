class AddBranchIdToEtlCirculations < ActiveRecord::Migration
  def change
    add_column :etl_circulations, :branch_id, :integer
  end
end
