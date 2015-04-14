class EtlPlan < ActiveRecord::Base
end

 source :input,
  {
  :type => :database,
  :target => :memp_development,
  :table => "plans",
  :select => "id  , name ",
  :conditions => "rownum <= 1000"
  },
  [
    :id,
    :name
  ]


transform(:name) do |n,v,r|
  r[:name]
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
