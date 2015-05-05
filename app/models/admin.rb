class Admin < ActiveRecord::Base

  
	def self.all_tables
    Rails.application.eager_load!	 
    arr=[]
		ActiveRecord::Base.descendants.each do |table|
		  if table._accessible_attributes?
		    arr << table.name
		  end
		end
	  arr
	end

  def self.all_attributes(table)
  	Rails.application.eager_load!        # Loads modals
    table = table.classify.constantize       # convert string to actual class  (Casting)
		attri = table.column_names              # attributes of the model
	end

  def self.all_associations(table)
  	asso_hash = {}
  	Rails.application.eager_load!        
    table =table.classify.constantize                       # convert string to actual class  (Casting)
	  table.reflections.keys.each do |tname|         
	           # all associations of the model ,keys are table_names , macro is the association_name
      if asso_hash[table.reflections[tname].macro].nil?
      	asso_hash[table.reflections[tname].macro]=[tname]
      else 
        asso_hash[table.reflections[tname].macro] << tname
      end
    end
    asso_hash
  end


  def self.table_to_modal(table1)
    Rails.application.eager_load!
    tablehash = Hash[ActiveRecord::Base.descendants.collect{|c| [c.table_name, c.name]}]
    tablehash[table1]
  end

  def self.modal_to_table(modal1)
    modal1.classify.constantize.table_name
  end

  def self.association_to_table(asso)
    asso.pluralize
  end

#Feature 1
  def self.joinstring(table1,table2,whichjoin,flag)     ## table1,table2 are table names
    Rails.application.eager_load!
    tablehash = Hash[ActiveRecord::Base.descendants.collect{|c| [c.table_name, c.name]}]

    reflex1 = tablehash[table1.pluralize].classify.constantize.reflections[table2.pluralize.to_sym]
    if reflex1 == nil
     reflex1 = tablehash[table1.pluralize].classify.constantize.reflections[table2.singularize.to_sym]
    end  
    reflex2 = tablehash[table2.pluralize].classify.constantize.reflections[table1.pluralize.to_sym]
    if reflex2 == nil
      reflex2 = tablehash[table2.pluralize].classify.constantize.reflections[table1.singularize.to_sym]
    end  
    asso1 = reflex1.macro.to_s
    asso2 = reflex2.macro.to_s
    attrr1 = reflex1.options[:foreign_key]
    attrr2 = reflex2.options[:foreign_key]
    if attrr1 == nil
      attrr1 = "id"
    end 
    if attrr2 == nil
      attrr2 = "id"
    end 
    if flag == 1
      return " #{whichjoin} #{table2.pluralize} on #{table1.pluralize}.#{attrr1} = #{table2.pluralize}.#{attrr2}"
    else
      return ", #{table1.pluralize} #{whichjoin} #{table2.pluralize} on #{table1.pluralize}.#{attrr1} = #{table2.pluralize}.#{attrr2}"
    end  
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

#calling multiple_join method
  def self.join_order_operation(reportobj)
    var =1
    joinstr = ""
    maintable=reportobj.jointables.first.table1
    reportobj.jointables.each do |x|
      joinstr << joinstring(x.table1,x.table2,x.whichjoin,var)
      var = var +1
    end
    
    orderstr = ""
    reportobj.ordertables.each do |x|
      orderstr << x.table_attribute + " " + x.desc_asce + ","
    end
    orderstr = orderstr[0..orderstr.length-2]  
    
    joined_table = multiple_join(maintable,joinstr,orderstr)
  end

#calling filters method
  def self.where_operation(joined_table,reportobj)
    wherestr = []
    wherestr[0]=""
    reportobj.wheretables.each do |x|
       wherestr[0] << x.table_attribute + " " + x.r_operator + " " + "?" + "and"
       wherestr << x.value
    end
    wherestr[0] = wherestr[0][0..wherestr[0].length-4]
    after_where = filters(joined_table,wherestr)
  end

#calling group_having method
  def self.group_having_operations(after_where,reportobj)
    groupstr = ''     
    reportobj.grouptables.each do |x|
       groupstr << x.table_attribute + ","
    end 
    groupstr=groupstr[0..groupstr.length-2]
    havingstr=[]
    havingstr[0] = ""
    reportobj.havingtables.each do |x|
       havingstr[0] << x.table_attribute + " " + x.r_operator + " " + "?" + "and"
       havingstr << x.value
    end
    havingstr[0] = havingstr[0][0..havingstr[0].length-4]
    after_group_having = group_having(groupstr,havingstr,after_where)
  end
  
#calling select_attr method 
  def self.select_operation(after_group_having,reportobj)
    selectstr = ""
    reportobj.selecttables.each do |x|
       selectstr << x.table_attribute + ","
    end  
    if selectstr.length > 2
    selectstr = selectstr[0..selectstr.length-2]
    end

    if selectstr == ""
      after_select = select_attr(after_group_having,"*")
    else        
      after_select = select_attr(after_group_having,selectstr)
    end
  end

#calling retrive_data
  def self.retrive_data(id)
    reportobj=Report.find(id)
    if id == nil
      return "Error report doesnot get saved"
    end

    joined_table = join_order_operation(reportobj)                       # Joining of tables and ordering of table
    after_where  = where_operation(joined_table,reportobj)               # appling filters on table
    after_group_having = group_having_operations(after_where,reportobj)  # appling group by and having 
    after_select = select_operation(after_group_having,reportobj)        # appling select operation

  end

end