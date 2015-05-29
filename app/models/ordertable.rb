class Ordertable < ActiveRecord::Base
  attr_accessible :desc_asce, :expo_default_flag, :report_id, :table_attribute
  
  belongs_to :report
  
end
