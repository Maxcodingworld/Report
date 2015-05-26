class Admin < ActiveRecord::Base
  class << self
    def tables_model_hash
      Rails.application.eager_load!	 
      Hash[ActiveRecord::Base.descendants.collect{|c| [c.table_name, c.name] unless c.accessible_attributes.empty?}]
  	end

    def all_attributes(table)
    	Rails.application.eager_load!        # Loads modals
      table.classify.constantize.column_names              # attributes of the model
  	end

    def all_associations(table)
      hash = Hash.new
      [:belongs_to,:has_many,:has_one,:has_and_belongs_to_many].each do |a| hash[a]=[] end
      table.classify.constantize.reflections.keys.collect {|c| hash[table.classify.constantize.reflections[c].macro] << c }
      hash  
    end

    def attribute_type(table_attribute)
      table_attribute.split('.').first.classify.constantize.columns_hash[table_attribute.split('.').last].type.to_s
    end

    def modal_to_table(modal1)
      modal1.classify.constantize.table_name
    end

    def association_to_table(asso)
      asso.pluralize
    end

  #Feature 1
    def reflection_betn_two_tables(table1,table2)
      reflex = table1.classify.constantize.reflections[table2.pluralize.to_sym]
      reflex = table1.classify.constantize.reflections[table2.singularize.to_sym] if reflex == nil
      reflex
    end  

    def joinstring(table1,table2,whichjoin,flag)     ## table1,table2 are table names
      Rails.application.eager_load!
      tablehash = tables_model_hash
      asso1 = reflection_betn_two_tables(tablehash[table1.pluralize],table2).macro.to_s
      asso2 = reflection_betn_two_tables(tablehash[table2.pluralize],table1).macro.to_s
      attrr1 = "id" if (attrr1 = reflection_betn_two_tables(tablehash[table1.pluralize],table2).options[:foreign_key]) == nil
      attrr2 = "id" if (attrr2 = reflection_betn_two_tables(tablehash[table2.pluralize],table1).options[:foreign_key]) == nil
      return flag == 1 ? " #{whichjoin} #{table2.pluralize} on #{table1.pluralize}.#{attrr1} = #{table2.pluralize}.#{attrr2}" : ", #{table1.pluralize} #{whichjoin} #{table2.pluralize} on #{table1.pluralize}.#{attrr1} = #{table2.pluralize}.#{attrr2}"
    end

    def multiple_join(table1,joinstr,order)
      stage1=Class.new
      stage1=table1.classify.constantize.joins("#{joinstr}").order(order)
    end

  #Feature 2
    def select_attr(stage1,selectstr)
      stage2=Class.new
      stage2=stage1.select(selectstr)
    end

  #Feature 3
    def group_having(groupstr,havingstr,stage2)
      stage3=Class.new
      stage3=stage2.group(groupstr).having(havingstr)
    end

  #Feature 4
    def filters(stage3,wherestr)
      stage4=Class.new
      stage4=stage3.where(wherestr)
    end

  #Feature 5
    def pagination(stage4,pageno = 1 ,perpage =10)
      stage5=Class.new
      stage5=stage4.paginate(:per_page => perpage , :page => pageno) 
    end  

  # Collect full joinstring into one
    def joinstrcollect(reportobj)
      var =1
      joinstr = ""
      reportobj.jointables.each do |x|
        joinstr << joinstring(x.table1,x.table2,x.whichjoin,var)
        var = var +1
      end
      joinstr
    end

  # Collect full orderstring into one
    def orderstrcollect(reportobj)
      orderstr = ""
      reportobj.ordertables.collect { |x| orderstr << x.table_attribute + " " + x.desc_asce + "," }
      orderstr = orderstr[0..orderstr.length-2]  
    end

  #calling multiple_join method
    def join_order_operation(reportobj)
      maintable=reportobj.maintable.table
      joinstr = joinstrcollect(reportobj)
      orderstr = orderstrcollect(reportobj)
      joined_table = multiple_join(maintable,joinstr,orderstr)
    end

  # Collect full wherestring into one
    def wherestrcollect(reportobj,exposed)
      wherestr = []
      wherestr[0]=""
      exposed = {} if exposed == nil
      reportobj.wheretables.each do |x|
         next if x.expo_default_flag == '1' and exposed[x.table_attribute] == nil
         wherestr[0] << x.table_attribute + " " + x.r_operator + " " + "?" + "and"
         wherestr << x.value if x.expo_default_flag == '0'
         wherestr << exposed[x.table_attribute] if x.expo_default_flag == '1' 
         wherestr << x.value if x.expo_default_flag == '2' and exposed[x.table_attribute] == nil 
         wherestr << exposed[x.table_attribute] if x.expo_default_flag == '2' and exposed[x.table_attribute] != nil 
      end
      wherestr[0] = wherestr[0][0..wherestr[0].length-4]
      return '' if wherestr[0].empty?
      wherestr
    end

  #calling filters method
    def where_operation(joined_table,reportobj,exposed)
      wherestr = wherestrcollect(reportobj,exposed) if reportobj.wheretables.present?
      after_where = filters(joined_table,wherestr)
    end

  #collect full groupstring into one
    def groupstrcollect(reportobj)
      groupstr = ''     
      reportobj.grouptables.collect { |x|  groupstr << x.table_attribute + "," } 
      groupstr=groupstr[0..groupstr.length-2]
    end

  #collect full havingstring into one
    def havingstrcollect(reportobj,exposed)
      havingstr=[]
      havingstr[0] = ""
      exposed = {} if exposed == nil
      reportobj.havingtables.each do |x|
         next if x.expo_default_flag == '1' and exposed[x.table_attribute] == nil
         havingstr[0] << x.table_attribute + " " + x.r_operator + " " + "?" + "and"
         havingstr << x.value if x.expo_default_flag == '0'
         havingstr << exposed[x.table_attribute] if x.expo_default_flag == '1'
         havingstr << x.value if x.expo_default_flag == '2' and exposed[x.table_attribute] == nil
         havingstr << exposed[x.table_attribute] if x.expo_default_flag == '2' and exposed[x.table_attribute] != nil
      end
      havingstr[0] = havingstr[0][0..havingstr[0].length-4]
      return '' if havingstr[0].empty?
      havingstr
    end   

  #calling group_having method
    def group_having_operations(after_where,reportobj,exposed)
      groupstr = groupstrcollect(reportobj)
      havingstr = havingstrcollect(reportobj,exposed) if reportobj.havingtables.present?
      after_group_having = group_having(groupstr,havingstr,after_where)
    end
    
  #collect full selectstr into one
    def selectstrcollect(reportobj)
      selectstr = ""
      reportobj.selecttables.collect { |x| selectstr << x.table_attribute + "," }
      selectstr = selectstr[0..selectstr.length-2] if selectstr.length > 2
    end 

  #calling select_attr method 
    def select_operation(after_group_having,reportobj)
      selectstr = selectstrcollect(reportobj)
      return after_select = select_attr(after_group_having,"*") if selectstr == ""
      return after_select = select_attr(after_group_having,selectstr)
    end

  #calling retrive_data
    def retrive_data(id,wherehash,havinghash)
      reportobj=Report.find(id.to_i)
      return "Error report doesnot get saved" if id == nil
      joined_table = join_order_operation(reportobj)                       # Joining of tables and ordering of table
      after_where  = where_operation(joined_table,reportobj,wherehash)               # appling filters on table
      after_group_having = group_having_operations(after_where,reportobj,havinghash)  # appling group by and having 
      after_select = select_operation(after_group_having,reportobj)        # appling select operation
    end
  

    def selectinfo(reportobj,info)
      if reportobj.selecttables.present?
        reportobj.selecttables.each do |x|
          info["expected_values"] << x.table_attribute
        end  
      else
        table = reportobj.maintable.table
        table.classify.constantize.column_names.each do |x|
          info["expected_values"] << table + "." + x
        end
      end
      info
    end
    
    def wher_hav_info(x)
      if x.expo_default_flag != '0'
        temp = {}
        temp[x.table_attribute.split(".").first] = x.table_attribute.split(".").last
        temp["default"] = nil
        temp["default"] = x.value if x.expo_default_flag == '2'
        temp["operator"] = x.r_operator
      end
      temp
    end

    def whereinfo(reportobj,info)
      if reportobj.wheretables.present?
        reportobj.wheretables.each do |x|
         info["exposed_where_values"] << wher_hav_info(x)   
        end 
      end
      info
    end
    
    def havinginfo(reportobj,info)
      if reportobj.havingtables.present?
        reportobj.havingtables.each do |x|
          info["exposed_having_values"] << wher_hav_info(x) 
        end  
      end
      info
    end 


    def information(id)
      reportobj =Report.find(id.to_i)
      info = {}  
      info["discription"] = reportobj.description
      info["expected_values"] = []
      info["exposed_where_values"] = []
      info["exposed_having_values"] = []
      info = selectinfo(reportobj,info)
      info = whereinfo(reportobj,info)
      info = havinginfo(reportobj,info)
    end
  end
end