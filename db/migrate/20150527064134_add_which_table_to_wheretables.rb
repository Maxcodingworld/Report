class AddWhichTableToWheretables < ActiveRecord::Migration
  def change
    add_column :wheretables, :which_table, :string
  end
end
