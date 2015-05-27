class AddWhichFieldToHavingtables < ActiveRecord::Migration
  def change
    add_column :havingtables, :which_field, :string
  end
end
