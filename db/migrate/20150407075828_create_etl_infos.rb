class CreateEtlInfos < ActiveRecord::Migration
  def change
    create_table :etl_infos do |t|
      t.string :table_name
      t.integer :last_etl_id

      t.timestamps
    end
  end
end
