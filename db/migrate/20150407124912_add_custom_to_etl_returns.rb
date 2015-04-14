class AddCustomToEtlReturns < ActiveRecord::Migration
  def change
    add_column :etl_returns, :custom, :date
  end
end
