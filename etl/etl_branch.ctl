class EtlBranch < ActiveRecord::Base
end

 source :input,
  {
  :type => :database,
  :target => :memp_development,
  :table => "branches",
  :select => "id  , name , category  "
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
  :target => :etl_execution,
  :table => "etl_branches"
},
{
  :primarykey => [:id],
  :order =>[:id,:name,:category]
} 
