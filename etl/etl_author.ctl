class EtlAuthor < ActiveRecord::Base
  establish_connection "production"
  self.table_name =  'etl_authors'
end


class EtlInfo < ActiveRecord::Base
  establish_connection "production"
  self.table_name =  'etl_infos'
end

  a = 0

  if EtlInfo.find_by_table_name("authors")
    a = EtlInfo.find_by_table_name("authors").last_etl_id
  end
 
 source :input,
  {
  :type => :database,
  :target => :webstore_production,
  :query => "select * from (select id ,name from authors order by id) where id > #{a}"
  },
  [
    :name
  ]

transform(:name) do |n,v,r|
  r[:name]
end


destination :out, {
  :type => :database,
  :target => :production,
  :table => "etl_authors"
},
{
  :primarykey => [:id],
  :order =>[:id,:name]
} 

post_process{
   
  a = EtlAuthor.connection.execute("SELECT MAX(ID) FROM etl_authors").fetch[0].to_i
  if !EtlInfo.find_by_id(6)

    EtlInfo.connection.execute("INSERT into etl_infos(id,table_name,last_etl_id,created_at,updated_at) values (6,'authors',#{a},sysdate,sysdate )")
  else 
    EtlInfo.connection.execute("UPDATE etl_infos SET id=6,table_name='authors',last_etl_id=#{a},created_at=sysdate,updated_at=sysdate
    where id = 6 ")
  end
}