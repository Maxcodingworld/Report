class EtlMemberProfileInfo < ActiveRecord::Base
end

 source :input,
  {
  :type => :database,
  :target => :memp_development,
  :table => "member_profiles",
  :select => "id  , email_id , first_name, last_name"
  },
  [
    :email_id,
    :first_name,
    :last_name
  ]


transform(:email) do |n,v,r|
  r[:email_id]
end

transform(:name) do |n,v,r|
  if r[:last_name]
    r[:first_name]+" "+r[:last_name]
  else
    r[:first_name]
  end
end




destination :out, {
  :type => :database,
  :target => :etl_execution,
  :table => "etl_member_profile_infos"
},
{
  :primarykey => [:id],
  :order =>[:id,:email,:name]
} 
