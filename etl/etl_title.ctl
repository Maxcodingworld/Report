class EtlTitle < ActiveRecord::Base
  establish_connection "production"
  self.table_name =  'etl_titles'
end


class EtlInfo < ActiveRecord::Base
  establish_connection "production"
  self.table_name =  'etl_infos'
end

  a = 0

  if EtlInfo.find_by_table_name("titles")
    a = EtlInfo.find_by_table_name("titles").last_etl_id
  end

 source :input,
  {
  :type => :database,
  :target => :webstore_production,
  :query => "select * from (select id ,title,author_id,category_id from titles order by id) where id > #{a}"

  },
  [
    :title,
    :author_id,
    :category_id
  ]

transform(:title) do |n,v,r|
  r[:title]
end

transform(:author_id) do |n,v,r|
  r[:author_id].to_i
end

transform(:category_id) do |n,v,r|
  r[:category_id].to_i
end


destination :out, {
  :type => :database,
  :target => :production,
  :table => "etl_titles"
},
{
  :primarykey => [:id],
  :order =>[:id,:title,:author_id,:category_id]
} 

post_process{
   
  a = EtlTitle.connection.execute("SELECT MAX(ID) FROM etl_titles").fetch[0].to_i
  if !EtlInfo.find_by_id(4)

    EtlInfo.connection.execute("INSERT into etl_infos(id,table_name,last_etl_id,created_at,updated_at) values (4,'titles',#{a},sysdate,sysdate )")
  else 
    EtlInfo.connection.execute("UPDATE etl_infos SET id=4,table_name='titles',last_etl_id=#{a},created_at=sysdate,updated_at=sysdate
    where id = 4 ")
  end

}