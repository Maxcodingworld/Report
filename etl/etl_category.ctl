class EtlCategory < ActiveRecord::Base
end

 source :input,
  {
  :type => :database,
  :target => :webstore_development,
  :table => "categories",
  :select => "id ,name,category_type"
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
