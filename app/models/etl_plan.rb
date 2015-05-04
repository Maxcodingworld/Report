class EtlPlan < ActiveRecord::Base
  attr_accessible :name

  has_many :etl_member_plans

end
