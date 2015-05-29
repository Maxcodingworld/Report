class EtlMemberProfileInfo < ActiveRecord::Base
  attr_accessible :email, :name
  has_many :etl_member_plans
end
