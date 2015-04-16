class EtlMemberProfileInfo < ActiveRecord::Base
  establish_connection "production"
  self.table_name =  'etl_member_profile_infos'
end


class EtlInfo < ActiveRecord::Base
  establish_connection "production"
  self.table_name =  'etl_infos'
end   
 
 a = 0

  if EtlInfo.find_by_table_name("member_profiles")
    a = EtlInfo.find_by_table_name("member_profiles").last_etl_id
  end

 source :input,
  {
  :type => :database,
  :target => :memp_production,
  :table => "member_profiles",
  :query => "select * from (select id , email_id , first_name, last_name from member_profiles order by id) where id > #{a}"
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
  :target => :production,
  :table => "etl_member_profile_infos"
},
{
  :primarykey => [:id],
  :order =>[:id,:email,:name]
} 

post_process{
   
  a = EtlMemberProfileInfo.connection.execute("SELECT MAX(ID) FROM ETL_MEMBER_PROFILE_INFOS").fetch[0].to_i
  if !EtlInfo.find_by_id(3)

    EtlInfo.connection.execute("INSERT into etl_infos(id,table_name,last_etl_id,created_at,updated_at) values (3,'member_profiles',#{a},sysdate,sysdate )")
  else 
    EtlInfo.connection.execute("UPDATE etl_infos SET id=3,table_name='member_profiles',last_etl_id=#{a},created_at=sysdate,updated_at=sysdate
    where id = 3 ")
  end

}