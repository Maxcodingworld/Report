class AddTitleIdToEtlReturns < ActiveRecord::Migration
  def change
    add_column :etl_returns, :title_id, :integer
  end
end
