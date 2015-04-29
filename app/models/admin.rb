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

#feature 1
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
    return "#{whichjoin} #{table2.pluralize} on #{table1.pluralize}.#{attrr1} = #{table2.pluralize}.#{attrr2}"
  else
    return "#{table1.pluralize} #{whichjoin} #{table2.pluralize} on #{table1.pluralize}.#{attrr1} = #{table2.pluralize}.#{attrr2}"
  end  
end

def self.multiple_join(table1,joinstr,order)
  stage1=Class.new
  stage1=table1.classify.constantize.joins("#{joinstr}").order(order)
end

def self.select_attr(stage1,selectstr)
  stage2=Class.new
  stage2=stage1.select(selectstr)
end

#Feature 3
  def self.group_having(groupstr,havingstr,stage2,aggregatestr)
    stage3=Class.new
    stage3=stage2.group(groupstr).having(havingstr).select(aggregatestr)
  end


#Feature 4
  def self.filters(stage3,wherestr)
    stage4=Class.new
    stage4=stage3.where(wherestr)
  end

#Feature 5
  def self.pagination(fromrow,torow,stage4)
    stage5=Class.new
    stage5=stage4.where("rownum >= #{fromrow} and rownum <= #{torow}") 
  end  




#populating tables

  def self.populate(userhash)
    
    reportobj = Report.new(:description => userhash["description"],:invoke_times => 0)
    reportobj.save!
    id = reportobj.id 

    if userhash["join"] != nil
      userhash["join"].keys.each do |x|
        joinobj = Jointable.new(:report_id => reportobj.id,:table1 => x ,:table2 => userhash["join"][x].first,:whichjoin => userhash["join"][x].last)           
        joinobj.save!
    end

    if userhash["group"] != nil
      userhash["group"].keys.each do |x|     
        groupobj = Grouptable.new(:report_id => reportobj.id,:table_attribute => x + "." + userhash["group"][x])           
        groupobj.save!    
    end

    if userhash["having"] != nil
      userhash["having"].keys.each do |x|     
        havingobj = Havingtable.new(:report_id => reportobj.id,:table_attribute => x + "." + userhash["having"][x].first
          ,:value => userhash["having"][x].first(3).last ,:r_operator => userhash["having"][x].first(2).last 
          ,:expo_default_flag => userhash["having"][x].last)           
        havingobj.save!    
    end

    if userhash["order"] != nil
      userhash["order"].keys.each do |x|     
        orderobj = Ordertable.new(:report_id => reportobj.id,:table_attribute => x + "." + userhash["order"][x].first
          ,:desc_asce =>userhash["order"][x].first(2).last ,:expo_default_flag => userhash["order"][x].last)           
        orderobj.save!    
    end

    if userhash["where"] != nil
      userhash["where"].keys.each do |x|     
        whereobj = Wheretable.new(:report_id => reportobj.id,:table_attribute => x + "." + userhash["where"][x].first
          ,:value => userhash["where"][x].first(3).last ,:r_operator => userhash["where"][x].first(2).last 
          ,:expo_default_flag => userhash["where"][x].last)           
        whereobj.save!    
    end      
    
    if userhash["select"] != nil
      userhash["select"].keys.each do |x|     
        selectobj = Selecttable.new(:report_id => reportobj.id,:table_attribute => x + "." + userhash["select"][x])           
        selectobj.save!    
    end 
  end
end