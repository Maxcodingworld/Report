class Wheretable < ActiveRecord::Base
  attr_accessible :expo_default_flag, :r_operator, :report_id, :table_attribute, :value,:which_table,:which_field
  validates_presence_of :r_operator
  belongs_to :report
end
