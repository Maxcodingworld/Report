class AddWhichFieldToShowToHavingtables < ActiveRecord::Migration
  def change
    add_column :havingtables, :which_field_to_show, :string
  end
end
