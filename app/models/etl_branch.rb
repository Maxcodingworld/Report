class EtlBranch < ActiveRecord::Base
  attr_accessible :category, :name

  has_many :etl_member_plans , :foreign_key => 'branch_id'
end
