class EtlReturn < ActiveRecord::Base
establish_connection "production"
  self.table_name =  'etl_returns'
end

class Return < ActiveRecord::Base
  establish_connection "memp_production"
  self.table_name =  'returns'
end

class EtlInfo < ActiveRecord::Base
  establish_connection "production"
  self.table_name =  'etl_infos'
end   
 
 a = 0

  if EtlInfo.find_by_table_name("returns")
    a = EtlInfo.find_by_table_name("returns").last_etl_id
  end
  

 source :input,
  {
  :type => :database,
  :target => :memp_production,
  :table => "returns",
  :query => "select * from (select id ,member_plan_id as m_p_i ,issue_date ,return_date ,branch_id ,legacy_title_id as t_id,created_at,updated_at,rent_duration from returns order by id) where id > #{a} and rownum <= 10 "
  },
  [
    :m_p_i,
    :issue_date,
    :return_date,
    :branch_id,
    :t_id,
    :created_at,
    :updated_at,
    :rent_duration
  ]


transform(:member_plan_id) do |n,v,r|
  r[:m_p_i].to_i
end

transform(:issue_date) do |n,v,r|
  r[:issue_date].to_date
end

transform(:return_date) do |n,v,r|
  r[:return_date].to_date
end

transform(:issue_branch_id) do |n,v,r|
  r[:branch_id].to_i
end

transform(:title_id) do |n,v,r|
  r[:t_id].to_i
end

transform(:created_at) do |n,v,r|
  r[:created_at].to_date
end

transform(:updated_at) do |n,v,r|
  r[:updated_at].to_date
end

transform(:rent_duration) do |n,v,r|
  r[:rent_duration].to_i
end

transform(:custom) do |n,v,r|
  Date.today.to_date
end

destination :out, {
  :type => :database,
  :target => :production,
  :table => "etl_returns"
},
{
  :primarykey => [:id],
  :order =>[:id,:member_plan_id,:issue_date,:return_date,:issue_branch_id,:title_id,:created_at,:updated_at,:rent_duration,:custom]
} 

post_process{
  a = EtlReturn.connection.execute("SELECT MAX(ID) FROM ETL_RETURNS").fetch[0].to_i
  if !EtlInfo.find_by_id(1)
    EtlInfo.connection.execute("INSERT into etl_infos(id,table_name,last_etl_id,created_at,updated_at) values (1,'returns',#{a},sysdate,sysdate )")
  else 
    EtlInfo.connection.execute("UPDATE etl_infos SET id=1,table_name='returns',last_etl_id=#{a},created_at=sysdate,updated_at=sysdate
    where id = 1 ")
  end

}

