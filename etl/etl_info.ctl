class EtlInfo < ActiveRecord::Base
end
class Return < ActiveRecord::Base
  establish_connection "memp_development"
  self.table_name =  'returns'
end

 

 source :input,
  {
  :type => :database,
  :target => :memp_development,
  :table => "returns",
  :query => "select max(id) as id from (select id from returns where rownum <= 1000 order by returns.id)",
  :new_records => "created_at"
  },
  [
   
  ]


transform(:last_etl_id) do |n,v,r|
   p r[:id].to_i
end

transform(:table_name) do |n,v,r|
  "returns"
end


transform(:created_at) do |n,v,r|
  Date.today.to_date
end

transform(:updated_at) do |n,v,r|
  Date.today.to_date
end

destination :out, {
  :type => :database,
  :target => :etl_execution,
  :table => "etl_infos"
},
{
  :primarykey => [:id],
  :order =>[:id,:table_name,:last_etl_id,:created_at,:updated_at]
} 
