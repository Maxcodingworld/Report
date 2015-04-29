class Jointable < ActiveRecord::Base
  attr_accessible :report_id, :table1, :table2, :whichjoin

  belongs_to :reports
end
