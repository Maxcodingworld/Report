class Maintable < ActiveRecord::Base
  attr_accessible :report_id, :table
  belongs_to :report
end
