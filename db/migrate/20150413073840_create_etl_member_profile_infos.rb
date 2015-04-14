class CreateEtlMemberProfileInfos < ActiveRecord::Migration
  def change
    create_table :etl_member_profile_infos do |t|
      t.string :email
      t.string :name
    end
  end
end
