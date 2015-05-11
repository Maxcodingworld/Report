class Report < ActiveRecord::Base
  attr_accessible :description, :invoke_times ,:selecttables_attributes,:wheretables_attributes,
  :jointables_attributes,:havingtables_attributes,:ordertables_attributes,:grouptables_attributes,:maintable_attributes

  validate :maintable_table_should_be_present
  validate :having_without_group
  validate :group_without_select
  validate :select_according_to_group
  validate :validity_of_attributes
  
  
  has_many :selecttables
  has_many :wheretables
  has_many :jointables
  has_many :havingtables
  has_many :ordertables
  has_many :grouptables
  has_one :maintable

  
  accepts_nested_attributes_for :selecttables, allow_destroy: true
  accepts_nested_attributes_for :jointables  , allow_destroy: true
  accepts_nested_attributes_for :wheretables , allow_destroy: true
  accepts_nested_attributes_for :grouptables , allow_destroy: true
  accepts_nested_attributes_for :havingtables, allow_destroy: true
  accepts_nested_attributes_for :ordertables , allow_destroy: true
  accepts_nested_attributes_for :maintable  , allow_destroy: true
  
  def maintable_table_should_be_present
     errors.add(:maintable,"should not empty") unless self.maintable.present?
  end

  def having_without_group
    if !(self.grouptables.present?)
      if (self.havingtables.present?)
        errors.add(:grouptables,"is nil and having table isn't nil")
      end 
    end
  end

  def group_without_select
    if !(self.selecttables.present?)
      if (self.grouptables.present?)
        errors.add(:grouptables,"is not nil and selecttables is nil")
      end 
    end
  end

  def select_according_to_group
      garr = []
      self.grouptables.each do |x| garr << x.table_attribute.split('.').last end
      self.selecttables.each do |x|  
        if (!(x.table_attribute.include?("(")) and !(garr.include?(x.table_attribute.split('.').last)) and !garr.empty?)
          errors.add(:grouptables,"group and select string is not compatible")
        end     
      end
  end

  def validity_of_attributes
    array=[]
    array = Admin.all_attributes(self.maintable.table) if self.maintable.present? and Admin.tables_model_hash.keys.include?(self.maintable.table)
    if !self.jointables.empty? 
      self.jointables.each do |x|
        array = array + Admin.all_attributes(x.table1)
        array = array + Admin.all_attributes(x.table2) 
      end
    end 
    
    self.selecttables.each do |x| 
      if !(array.include?(x.table_attribute.split("(").last.split(")").first.split(".").last))
        errors.add(:selecttables,"attributes of selecttable are not compatible")
      end
    end 
    
    self.wheretables.each do |x| 
      if !(array.include?(x.table_attribute.split("(").last.split(")").first.split(".").last))
        errors.add(:wheretables,"attributes of wheretable are not compatible")
      end
    end 
  

    self.ordertables.each do |x| 
      if !(array.include?(x.table_attribute.split("(").last.split(")").first.split(".").last))
        errors.add(:ordertables,"attributes of ordertable are not compatible")
      end
    end 
  

    self.havingtables.each do |x| 
      if !(array.include?(x.table_attribute.split("(").last.split(")").first.split(".").last))
        errors.add(:havingtables,"attributes of havingtable are not compatible")
      end
    end 
  
    self.grouptables.each do |x| 
      if !(array.include?(x.table_attribute.split("(").last.split(")").first.split(".").last))
        errors.add(:grouptables,"attributes of grouptable are not compatible")
      end
    end  
  end
end
