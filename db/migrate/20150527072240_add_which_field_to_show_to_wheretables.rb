class AddWhichFieldToShowToWheretables < ActiveRecord::Migration
  def change
    add_column :wheretables, :which_field_to_show, :string
  end
end
