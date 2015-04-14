class EtlMemberPlan < ActiveRecord::Base
end

 source :input,
  {
  :type => :database,
  :target => :memp_development,
  :table => "member_plans",
  :select => "id  , branch_id , plan_id ,member_profile_id"
  },
  [
    :id,
    :branch_id,
    :plan_id,
    :member_profile_id
  ]

transform(:branch_id) do |n,v,r|
  r[:branch_id].to_i
end

transform(:plan_id) do |n,v,r|
  r[:plan_id].to_i
end

transform(:member_profile_id) do |n,v,r|
  r[:member_profile_id].to_i
end


destination :out, {
  :type => :database,
  :target => :etl_execution,
  :table => "etl_member_plans"
},
{
  :primarykey => [:id],
  :order =>[:id,:branch_id,:plan_id,:member_profile_id]
} 
