class Maintable < ActiveRecord::Base
  attr_accessible :report_id, :table
  belongs_to :report
  
  validate :maintable_table_should_exist

  def maintable_table_should_exist
    unless Admin.tables_model_hash.keys.include?(table)
      errors.add(:maintable,"'s table_name is not correct")    
    end
  end
end
