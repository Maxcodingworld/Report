class EtlMemberPlan < ActiveRecord::Base
  establish_connection "etl_execution"
  self.table_name =  'etl_member_plans'
end


class EtlInfo < ActiveRecord::Base
  establish_connection "etl_execution"
  self.table_name =  'etl_infos'
end

  a = 0

  if EtlInfo.find_by_table_name("member_plans")
    a = EtlInfo.find_by_table_name("member_plans").last_etl_id
  end


 source :input,
  {
  :type => :database,
  :target => :memp_development,
  :query => "select * from (select id ,branch_id , plan_id ,member_profile_id from member_plans order by id) where id > #{a}"

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

post_process{
   
  a = EtlMemberPlan.connection.execute("SELECT MAX(ID) FROM ETL_member_plans").fetch[0].to_i
  if !EtlInfo.find_by_id(5)

    EtlInfo.connection.execute("INSERT into etl_infos(id,table_name,last_etl_id,created_at,updated_at) values (5,'member_plans',#{a},sysdate,sysdate )")
  else 
    EtlInfo.connection.execute("UPDATE etl_infos SET id=5,table_name='member_plans',last_etl_id=#{a},created_at=sysdate,updated_at=sysdate
    where id = 5 ")
  end

}