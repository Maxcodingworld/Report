class EtlTitle < ActiveRecord::Base
end

 source :input,
  {
  :type => :database,
  :target => :webstore_development,
  :table => "titles",
  :select => "id ,title,author_id,category_id",
  :conditions => "rownum <= 1000"
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
  :target => :etl_execution,
  :table => "etl_titles"
},
{
  :primarykey => [:id],
  :order =>[:id,:title,:author_id,:category_id]
} 
