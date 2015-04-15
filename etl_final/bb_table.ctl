class BbTable < ActiveRecord::Base
establish_connection "etl_execution"
self.table_name = "etl_books"
end


source :in, {
  :type => :database,
  :target => :etl_execution,
  :table => "etl_ibtr_versions",
  :conditions => "flag_destination != 'NA'",
  :new_records_only => "created_at_date" 
  },
  [
    :ibtr_id,
    :state,
    :created_by,
    :created_at_int,
    :updated_at_int,     
    :flag_destination,
    :book_id,
    :created_at_date,
    :updated_at_date
  ]

transform(:book_state) do |n,v,r|

  if r[:book_id].to_i == 0
      0
  end  

  a = BbTable.find_by_id(r[:book_id])
  if a
      if a.state == 'M'
          1
      else
          0
      end
  else 
      0
  end
end

transform(:created_at_date) do |n,v,r|
 r[:created_at_date].to_time
end


transform(:updated_at_date) do |n,v,r|
 r[:updated_at_date].to_time
end




destination :out, {
  :type => :database,
  :target => :etl_execution,
  :table => "temp2ibtrves"
},
{
   :primarykey => [:id],
   :order => [:id,:ibtr_id,:state,:created_by,:created_at_int,:updated_at_int,:flag_destination,:book_state,:created_at_date, :updated_at_date]
}
