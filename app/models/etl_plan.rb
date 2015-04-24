class EtlPlan < ActiveRecord::Base
  attr_accessible :name

  has_many :etl_member_plans , :foreign_key => 'plan_id'

end
