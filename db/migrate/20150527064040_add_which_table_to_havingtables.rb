class AddWhichTableToHavingtables < ActiveRecord::Migration
  def change
    add_column :havingtables, :which_table, :string
  end
end
