class EtlMemberPlan < ActiveRecord::Base
  attr_accessible :branch_id, :member_profile_id, :plan_id


    belongs_to :etl_branch , :foreign_key => 'branch_id'
    belongs_to :etl_plan , :foreign_key => 'plan_id'
    belongs_to :etl_member_profile_info , :foreign_key => 'member_profile_id'
    has_many :etl_circulations, :foreign_key => 'member_plan_id'
end
