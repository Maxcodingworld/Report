class AddLabelToWheretables < ActiveRecord::Migration
  def change
    add_column :wheretables, :label, :string
  end
end
