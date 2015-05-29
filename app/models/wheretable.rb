class Wheretable < ActiveRecord::Base
  attr_accessible :expo_default_flag, :r_operator, :label,:report_id,:table_attribute, :value,:which_table,:which_field,:which_field_to_show
  validates_presence_of :r_operator
  belongs_to :report
end
