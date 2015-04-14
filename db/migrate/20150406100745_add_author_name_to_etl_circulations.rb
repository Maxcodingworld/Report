class AddAuthorNameToEtlCirculations < ActiveRecord::Migration
  def change
    add_column :etl_circulations, :author_name, :string
  end
end
