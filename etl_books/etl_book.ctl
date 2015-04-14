class EtlBook < ActiveRecord::Base
establish_connection "etl_execution"
self.table_name = "etl_books"
end


max_id =0
max_id = EtlBook.connection.execute("select max(id) from etl_books").fetch[0].to_i
p max_id
EtlBook.connection.close


source :in, {
  :type => :database,
  :target => :opac_connection,
  :table => "books",
  :select => "id,state",
  :conditions => "books.id > #{max_id}",
  :order => "id"
  },
  [
    :state
  ]


destination :out, {
  :type => :database,
  :target => :etl_execution,
  :table => "etl_books"
},
{
   :primarykey => [:id],
   :order => [:id,:state]
}
