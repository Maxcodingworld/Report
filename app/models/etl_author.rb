class EtlAuthor < ActiveRecord::Base
  attr_accessible :name
  set_table_name "etl_authors"
end
