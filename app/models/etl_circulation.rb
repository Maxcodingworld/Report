class EtlCirculation < ActiveRecord::Base
  attr_accessible :author_id, :category_name, :category_type, :created_at_in_second, :issue_branch_id, :issue_date, :member_plan_id, :rent_duration, :return_date, :title_id, :updated_at_in_second
end
