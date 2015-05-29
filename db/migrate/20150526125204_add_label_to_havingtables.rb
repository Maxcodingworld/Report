class AddLabelToHavingtables < ActiveRecord::Migration
  def change
    add_column :havingtables, :label, :string
  end
end
