class Report < ActiveRecord::Base
  attr_accessible :description, :invoke_times

  has_many :selecttables
  has_many :wheretables
  has_many :jointables
  has_many :havingtables
  has_many :ordertables
  has_many :grouptables 



end
