class EtlCategory < ActiveRecord::Base
  establish_connection "etl_execution"
  self.table_name =  'etl_categories'
end


class EtlInfo < ActiveRecord::Base
  establish_connection "etl_execution"
  self.table_name =  'etl_infos'
end

  a = 0

  if EtlInfo.find_by_table_name("categories")
    a = EtlInfo.find_by_table_name("categories").last_etl_id
  end

 source :input,
  {
  :type => :database,
  :target => :webstore_develoment,
  :query => "select * from (select id ,name,category_type from categories order by id) where id > #{a}"
  },
  [
    :name,
    :category_type
  ]

transform(:name) do |n,v,r|
  r[:name]
end

transform(:category_type) do |n,v,r|
  r[:category_type]
end

destination :out, {
  :type => :database,
  :target => :etl_execution,
  :table => "etl_categories"
},
{
  :primarykey => [:id],
  :order =>[:id,:name,:category_type]
} 

post_process{
   
  a = EtlCategory.connection.execute("SELECT MAX(ID) FROM etl_categories").fetch[0].to_i
  if !EtlInfo.find_by_id(8)

    EtlInfo.connection.execute("INSERT into etl_infos(id,table_name,last_etl_id,created_at,updated_at) values (8,'categories',#{a},sysdate,sysdate )")
  else 
    EtlInfo.connection.execute("UPDATE etl_infos SET id=8,table_name='categories',last_etl_id=#{a},created_at=sysdate,updated_at=sysdate
    where id = 8 ")
  end
}