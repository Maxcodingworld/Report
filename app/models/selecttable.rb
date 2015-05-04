class Selecttable < ActiveRecord::Base
  attr_accessible :report_id, :table_attribute

  belongs_to :reports
end
