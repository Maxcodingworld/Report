class EtlBranch < ActiveRecord::Base
  establish_connection "production"
  self.table_name =  'etl_branches'
end


class EtlInfo < ActiveRecord::Base
  establish_connection "production"
  self.table_name =  'etl_infos'
end

  a = 0

  if EtlInfo.find_by_table_name("branches")
    a = EtlInfo.find_by_table_name("branches").last_etl_id
  end

 source :input,
  {
  :type => :database,
  :target => :memp_production,
  :query => "select * from (select id ,name, category from branches order by id) where id > #{a}  "
  },
  [
    :name,
    :category
  ]

transform(:name) do |n,v,r|
  r[:name]
end

transform(:category) do |n,v,r|
  r[:category]
end




destination :out, {
  :type => :database,
  :target => :production,
  :table => "etl_branches"
},
{
  :primarykey => [:id],
  :order =>[:id,:name,:category]
} 

post_process{
   
  a = EtlBranch.connection.execute("SELECT MAX(ID) FROM etl_branches").fetch[0].to_i
  if !EtlInfo.find_by_id(7)

    EtlInfo.connection.execute("INSERT into etl_infos(id,table_name,last_etl_id,created_at,updated_at) values (7,'branches',#{a},sysdate,sysdate )")
  else 
    EtlInfo.connection.execute("UPDATE etl_infos SET id=7,table_name='branches',last_etl_id=#{a},created_at=sysdate,updated_at=sysdate
    where id = 7 ")
  end
}