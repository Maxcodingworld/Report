class Report < ActiveRecord::Base
  attr_accessible :description, :invoke_times ,:selecttables_attributes,:wheretables_attributes,
  :jointables_attributes,:havingtables_attributes,:ordertables_attributes,:grouptables_attributes
  
  has_many :selecttables
  has_many :wheretables
  has_many :jointables
  has_many :havingtables
  has_many :ordertables
  has_many :grouptables 

  accepts_nested_attributes_for :selecttables, allow_destroy: true
  accepts_nested_attributes_for :jointables  , allow_destroy: true
  accepts_nested_attributes_for :wheretables , allow_destroy: true
  accepts_nested_attributes_for :grouptables , allow_destroy: true
  accepts_nested_attributes_for :havingtables, allow_destroy: true
  accepts_nested_attributes_for :ordertables , allow_destroy: true
end
