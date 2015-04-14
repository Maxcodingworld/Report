class CreateEtlMemberPlans < ActiveRecord::Migration
  def change
    create_table :etl_member_plans do |t|
      t.integer :branch_id
      t.integer :plan_id
      t.integer :member_profile_id
    end
  end
end
