class Havingtable < ActiveRecord::Base
  attr_accessible :expo_default_flag, :r_operator, :report_id, :table_attribute, :value
  
  belongs_to :reports
end
