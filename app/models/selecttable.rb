class Selecttable < ActiveRecord::Base
  attr_accessible :report_id, :table_attribute , :label

  belongs_to :report
end
