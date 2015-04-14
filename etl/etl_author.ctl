class EtlAuthor < ActiveRecord::Base
end

 source :input,
  {
  :type => :database,
  :target => :webstore_development,
  :table => "authors",
  :select => "id ,name"
  },
  [
    :name
  ]

transform(:name) do |n,v,r|
  r[:name]
end


destination :out, {
  :type => :database,
  :target => :etl_execution,
  :table => "etl_authors"
},
{
  :primarykey => [:id],
  :order =>[:id,:name]
} 
