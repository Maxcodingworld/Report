class AddMemberProfileIdToEtlCirculations < ActiveRecord::Migration
  def change
    add_column :etl_circulations, :member_profile_id, :integer
  end
end
