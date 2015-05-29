class AddWhichFieldToWheretables < ActiveRecord::Migration
  def change
    add_column :wheretables, :which_field, :string
  end
end
