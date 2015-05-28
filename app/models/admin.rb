class Admin < ActiveRecord::Base
  
	def self.tables_model_hash
    Rails.application.eager_load!	 
    Hash[ActiveRecord::Base.descendants.collect{|c| [c.table_name, c.name] unless c.accessible_attributes.empty?}]
	end

  def self.all_attributes(table)
  	Rails.application.eager_load!        # Loads modals
    table.classify.constantize.column_names              # attributes of the model
	end

  def self.all_associations(table)
    hash = Hash.new
    [:belongs_to,:has_many,:has_one,:has_and_belongs_to_many].each do |a| hash[a]=[] end
    table.classify.constantize.reflections.keys.collect {|c| hash[table.classify.constantize.reflections[c].macro] << c }
    hash  
  end

  def self.attribute_type(table_attribute)
    table_attribute.split('.').first.classify.constantize.columns_hash[table_attribute.split('.').last].type.to_s
  end

  def self.modal_to_table(modal1)
    modal1.classify.constantize.table_name
  end

  def self.association_to_table(asso)
    asso.pluralize
  end

#Feature 1
  def self.reflection_betn_two_tables(table1,table2)
    reflex = table1.classify.constantize.reflections[table2.pluralize.to_sym]
    reflex = table1.classify.constantize.reflections[table2.singularize.to_sym] if reflex == nil
    reflex
  end  

  def self.joinstring(table1,table2,whichjoin,flag)     ## table1,table2 are table names
    Rails.application.eager_load!
    tablehash = tables_model_hash
    asso1 = reflection_betn_two_tables(tablehash[table1.pluralize],table2).macro.to_s
    asso2 = reflection_betn_two_tables(tablehash[table2.pluralize],table1).macro.to_s
    attrr1 = "id" if (attrr1 = reflection_betn_two_tables(tablehash[table1.pluralize],table2).options[:foreign_key]) == nil
    attrr2 = "id" if (attrr2 = reflection_betn_two_tables(tablehash[table2.pluralize],table1).options[:foreign_key]) == nil
    return flag == 1 ? " #{whichjoin} #{table2.pluralize} on #{table1.pluralize}.#{attrr1} = #{table2.pluralize}.#{attrr2}" : ", #{table1.pluralize} #{whichjoin} #{table2.pluralize} on #{table1.pluralize}.#{attrr1} = #{table2.pluralize}.#{attrr2}"
  end

  def self.multiple_join(table1,joinstr,order)
    stage1=Class.new
    stage1=table1.classify.constantize.joins("#{joinstr}").order(order)
  end

#Feature 2
  def self.select_attr(stage1,selectstr)
    stage2=Class.new
    stage2=stage1.select(selectstr)
  end

#Feature 3
  def self.group_having(groupstr,havingstr,stage2)
    stage3=Class.new
    stage3=stage2.group(groupstr).having(havingstr)
  end

#Feature 4
  def self.filters(stage3,wherestr)
    stage4=Class.new
    stage4=stage3.where(wherestr)
  end

#Feature 5
  def self.pagination(stage4,pageno = 1 ,perpage =10)
    stage5=Class.new
    stage5=stage4.paginate(:per_page => perpage , :page => pageno) 
  end  

# Collect full joinstring into one
  def self.joinstrcollect(reportobj)
    var =1
    joinstr = ""
    reportobj.jointables.each do |x|
      joinstr << joinstring(x.table1,x.table2,x.whichjoin,var)
      var = var +1
    end
    joinstr
  end

# Collect full orderstring into one
  def self.orderstrcollect(reportobj)
    orderstr = ""
    reportobj.ordertables.collect { |x| orderstr << x.table_attribute + " " + x.desc_asce + "," }
    orderstr = orderstr[0..orderstr.length-2]  
  end

#calling multiple_join method
  def self.join_order_operation(reportobj)
    maintable=reportobj.maintable.table
    joinstr = joinstrcollect(reportobj)
    orderstr = orderstrcollect(reportobj)
    joined_table = multiple_join(maintable,joinstr,orderstr)
  end

# Collect full wherestring into one
  def self.wherestrcollect(reportobj)
    wherestr = []
    wherestr[0]=""
    reportobj.wheretables.each do |x|
       wherestr[0] << x.table_attribute + " " + x.r_operator + " " + "?" + "and"
       wherestr << x.value
    end
    wherestr[0] = wherestr[0][0..wherestr[0].length-4]
    wherestr
  end

#calling filters method
  def self.where_operation(joined_table,reportobj)
    wherestr = ''
    wherestr = wherestrcollect(reportobj) if reportobj.wheretables.present?
    after_where = filters(joined_table,wherestr)
  end

#collect full groupstring into one
  def self.groupstrcollect(reportobj)
    groupstr = ''     
    reportobj.grouptables.collect { |x|  groupstr << x.table_attribute + "," } 
    groupstr=groupstr[0..groupstr.length-2]
  end

#collect full havingstring into one
  def self.havingstrcollect(reportobj)
    havingstr=[]
    havingstr[0] = ""
    reportobj.havingtables.each do |x|
       havingstr[0] << x.table_attribute + " " + x.r_operator + " " + "?" + "and"
       havingstr << x.value
    end
    havingstr[0] = havingstr[0][0..havingstr[0].length-4]
    havingstr
  end   

#calling group_having method
  def self.group_having_operations(after_where,reportobj)
    havingstr = ''
    groupstr = groupstrcollect(reportobj)
    havingstr = havingstrcollect(reportobj) if reportobj.havingtables.present?
    after_group_having = group_having(groupstr,havingstr,after_where)
  end
  
#collect full selectstr into one
  def self.selectstrcollect(reportobj)
    selectstr = ""
    reportobj.selecttables.collect { |x| selectstr << x.table_attribute + "," }
    selectstr = selectstr[0..selectstr.length-2] if selectstr.length > 2
  end 

#calling select_attr method 
  def self.select_operation(after_group_having,reportobj)
    selectstr = selectstrcollect(reportobj)
    return after_select = select_attr(after_group_having,"*") if selectstr == ""
    return after_select = select_attr(after_group_having,selectstr)
  end

#calling retrive_data
  def self.retrive_data(id)
    reportobj=Report.find(id.to_i)
    return "Error report doesnot get saved" if id == nil
    
    joined_table = join_order_operation(reportobj)                       # Joining of tables and ordering of table
    after_where  = where_operation(joined_table,reportobj)               # appling filters on table
    after_group_having = group_having_operations(after_where,reportobj)  # appling group by and having 
    after_select = select_operation(after_group_having,reportobj)        # appling select operation
  end
end