class EtlPlan < ActiveRecord::Base
 establish_connection "etl_execution"
 self.table_name =  'etl_plans'
end




class EtlInfo < ActiveRecord::Base
  establish_connection "etl_execution"
  self.table_name =  'etl_infos'
end   

 
 a = 0

  if EtlInfo.find_by_table_name("plans")
    a = EtlInfo.find_by_table_name("plans").last_etl_id
  end

 source :input,
  {
  :type => :database,
  :target => :memp_development,
  :table => "plans",
  :query => "select * from (select id , name from plans order by id) where id > #{a}"
  },
  [
    :id,
    :name
  ]


transform(:name) do |n,v,r|
  p r[:name]
end

destination :out, {
  :type => :database,
  :target => :etl_execution,
  :table => "etl_plans"
},
{
  :primarykey => [:id],
  :order =>[:id,:name]
} 



post_process{
   
  a = EtlPlan.connection.execute("SELECT MAX(ID) FROM ETL_PLANS").fetch[0].to_i
  if !EtlInfo.find_by_id(2)

    EtlInfo.connection.execute("INSERT into etl_infos(id,table_name,last_etl_id,created_at,updated_at) values (2,'plans',#{a},sysdate,sysdate )")
  else 
    EtlInfo.connection.execute("UPDATE etl_infos SET id=2,table_name='plans',last_etl_id=#{a},created_at=sysdate,updated_at=sysdate
    where id = 2 ")
  end

}
