class AddLabelToSelecttables < ActiveRecord::Migration
  def change
    add_column :selecttables, :label, :string
  end
end
