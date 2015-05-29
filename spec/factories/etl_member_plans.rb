FactoryGirl.define do
  factory :etl_member_plan do
  etl_branch = FactoryGirl.build(:etl_branch)
  etl_branch.save
  branch_id etl_branch.id
  plan_id 2    
  member_profile_id 3
  end
end
