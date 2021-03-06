class Havingtable < ActiveRecord::Base
  attr_accessible :expo_default_flag, :r_operator, :label,:report_id,:table_attribute,:value ,:which_table,:which_field,:which_field_to_show
  belongs_to :report
  
  validate :having_attributes_empty 
  
  def having_attributes_empty
    errors.add(:havingtables,"table_attribute should not empty") if table_attribute == nil
  end
end
