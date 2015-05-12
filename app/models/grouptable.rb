class Grouptable < ActiveRecord::Base
  attr_accessible :report_id, :table_attribute
  belongs_to :report

  validate :group_table_attribute_empty

  def group_table_attribute_empty
      errors.add(:grouptables,"table_attributes should not empty") if table_attribute == nil 
  end 
end
