class EtlCategory < ActiveRecord::Base
  attr_accessible :category_type, :name
  set_table_name "etl_categories"
end
