class IbtrV < ActiveRecord::Base
establish_connection "opac_development"
self.table_name = "member_orders"
end


source :in, {
  :type => :database,
  :target => :opac_development,
  :table => "ibtr_versions",
  :select => "min(id) as id,ibtr_id,state,min(created_by) as created_by,min(created_at) as created_at,max(updated_at) as updated_at",
  :group => "ibtr_id,state",
  :new_records_only => "created_at"
  },
  [
    :ibtr_id,
    :state,
    :created_by,
    :created_at,
    :updated_at     
  ]

transform(:created_by) do |n,v,r|
   if r[:created_by]
     r[:created_by]
   else
    0 
   end
end

book_temp =0

transform(:flag_destination) do |n,v,r|
  a = IbtrV.find_by_ibtr_id(r[:ibtr_id])
  if a
  book_temp = a.book_id
  a.flag_destination
  else
  book_temp = 0
  'NA'
  end 

end

transform(:book_id) do |n,v,r|
  book_temp
end



transform(:created_at_int) do |n,v,r|
 r[:created_at].to_time.to_i
end


transform(:updated_at_int) do |n,v,r|
 r[:updated_at].to_time.to_i 
end

transform(:created_at_date) do |n,v,r|
 r[:created_at].to_time
end


transform(:updated_at_date) do |n,v,r|
 r[:updated_at].to_time
end



destination :out, {
  :type => :database,
  :target => :etl_execution,
  :table => "etl_ibtr_versions"
},
{
   :primarykey => [:id],
   :order => [:id,:ibtr_id,:state,:created_by,:created_at_int,:updated_at_int,:flag_destination,:book_id,:created_at_date, :updated_at_date]
}
