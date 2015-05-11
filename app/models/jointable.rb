class Jointable < ActiveRecord::Base
  attr_accessible :report_id, :table1, :table2, :whichjoin
  belongs_to :reports

  validates :table1 , :inclusion => { :in => ActiveRecord::Base.descendants.collect{|c| c.table_name} , :message => "%{value} Not a table"}
  validates :table2 , :inclusion => { :in => ActiveRecord::Base.descendants.collect{|c| c.table_name} , :message => "%{value} Not a table"}
  validate :association_between_tables
    
  def association_between_tables
    a = table1.classify.constantize
    if !(a.reflections.keys.include?(table2.singularize.to_sym) || a.reflections.keys.include?(table2.pluralize.to_sym))
      errors.add(:table1,"no association")
    end
  end
end


