class EtlReturn < ActiveRecord::Base
  attr_accessible :issue_branch_id, :issue_date, :member_plan_id, :rent_duration, :return_date
end
