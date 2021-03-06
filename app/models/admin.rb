class Admin < ActiveRecord::Base
  class << self
    def tables_model_hash
      Rails.application.eager_load!  
      Hash[ActiveRecord::Base.descendants.collect{|c| [c.table_name, c.name] unless c.accessible_attributes.empty?}].except("reports","jointables","selecttables","wheretables","ordertables","grouptables","havingtables","maintables")
    end


    def arrofgrp(id)
      arr = []
      reportobj = Report.find(id.to_i)
      reportobj.grouptables.each do |x|
        arr << x.table_attribute
      end
      arr
    end

    def operation_tables(id)
      arr = []
      option = []
      arr << Report.find(id.to_i).maintable.table

      Report.find(id.to_i).jointables.each do |x|
        arr << x.table1
        arr << x.table2
      end
      arr = arr.uniq
      arr.each do |x|
          option << [x,""]
          all_attributes(x).each do |cat|
            option << [cat,x+"."+cat]
          end
      end
      arr << arr.first
      [arr,option]
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
    
    def table_relation_table_and_attributes(table,attrr1)
      temp = table.classify.constantize.reflections
      temp.keys.each do |x|
        return [x,x.to_s.classify.constantize.column_names] if temp[x].foreign_key == attrr1
      end
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
      if (asso1 == "has_many") or (asso1 == "has_one")
        attrr2 = reflection_betn_two_tables(tablehash[table2.pluralize],table1).foreign_key
      end
      if (asso2 == "has_many") or (asso2 == "has_one")
        attrr1 = reflection_betn_two_tables(tablehash[table1.pluralize],table2).foreign_key
      end
      attrr2 = "id" if asso1 == "belongs_to"
      attrr1 = "id" if asso2 == "belongs_to"
      attrr2 = "id" if attrr2 == nil
      attrr1 = "id" if attrr2 == nil
      #return flag == 1 ? " #{whichjoin} #{table2.pluralize} on #{table1.pluralize}.#{attrr1} = #{table2.pluralize}.#{attrr2}" : ", #{table1.pluralize} #{whichjoin} #{table2.pluralize} on #{table1.pluralize}.#{attrr1} = #{table2.pluralize}.#{attrr2}"
      return " #{whichjoin} #{table2.pluralize} on #{table1.pluralize}.#{attrr1} = #{table2.pluralize}.#{attrr2}"
    end

    def multiple_join(table1,joinstr,order)
      stage1=Class.new
      stage1=table1.classify.constantize.joins("#{joinstr}").order(order)
    end

  #Feature 2
    def select_attr(stage1,selectstr) 
      stage2=Class.new
      stage2=stage1.pluck_details(selectstr)
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
      stage5 = stage4.paginate(:per_page => perpage , :page => pageno)
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
         next if x.expo_default_flag == '1' and exposed[x.table_attribute].blank?
         wherestr[0] << " " + x.table_attribute + " " + x.r_operator + " " + "? " + "and"
         wherestr << x.value if x.expo_default_flag == '0'
         wherestr << exposed[x.table_attribute] if x.expo_default_flag == '1' 
         wherestr << x.value if x.expo_default_flag == '2' and exposed[x.table_attribute].blank?
         wherestr << exposed[x.table_attribute] if x.expo_default_flag == '2' and exposed[x.table_attribute].blank? 
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
      reportobj.selecttables.each do |x| 
        tempstr =  '"' + x.table_attribute.split(".").first + "-" + x.table_attribute.split(".").last + '"'
        tempstr = '"' + x.label + '"' if x.label.present? 
        selectstr << x.table_attribute + " as " + tempstr + ","
      end
      selectstr = selectstr[0..selectstr.length-2] if selectstr.length > 2
    end 

  #calling select_attr method 
    def select_operation(after_group_having,reportobj)
      selectstr = selectstrcollect(reportobj)
      return after_select = select_attr(after_group_having,"*") if selectstr == ""
      return after_select = select_attr(after_group_having,selectstr)
    end

  #calling retrive_data
    def retrive_data(id,wherehash,havinghash,page=1)
      reportobj=Report.find(id.to_i)
      return "Error report doesnot get saved" if id == nil
      joined_table = join_order_operation(reportobj)                       # Joining of tables and ordering of table
      after_where  = where_operation(joined_table,reportobj,wherehash)               # appling filters on table
      after_group_having = group_having_operations(after_where,reportobj,havinghash)  # appling group by and having 
      after_paginate = pagination(after_group_having,page)
      total_entries = after_group_having.pluck_details("count(1) as count").first["count"] rescue 10
      after_select = select_operation(after_paginate,reportobj)        # appling select operation
      [after_select,total_entries]
    end
  

    def selectinfo(reportobj)
      info=[]
      if reportobj.selecttables.present?
        reportobj.selecttables.each do |x|
          info << x.table_attribute.split(".").first + "-" + x.table_attribute.split(".").last unless x.label.present?
          info << x.label if x.label.present?
        end  
      else
        table = reportobj.maintable.table
        table.classify.constantize.column_names.each do |x|
          info << x
        end
      end
      info
    end
    
    def wher_hav_info(x)
      if x.expo_default_flag != '0'
        temp = {}
        temp["table"] = x.table_attribute.split(".").first.split('(').last
        temp["attribute"]= x.table_attribute.split(".").last.split(')').first
        temp["default"] = x.value if x.expo_default_flag == '2'
        temp["operator"] = x.r_operator
        temp["label"] = x.label
        temp["which_table"] = x.which_table
        temp["which_field"] = x.which_field.split('.').last rescue ''
        temp["which_field_to_show"] = x.which_field_to_show.split('.').last rescue ''
      end
      temp
    end

    def whereinfo(reportobj)
      info = []
      if reportobj.wheretables.present?
        reportobj.wheretables.each do |x|
         temp = wher_hav_info(x)
         info << temp if temp.present?   
        end 
      end
      info
    end
    
    def havinginfo(reportobj,info)
      info = []
      agg = ["sum","max","min","avg","count"]
      if reportobj.havingtables.present?
        reportobj.havingtables.each do |x|
          tem =  wher_hav_info(x)
          info << tem if tem.present? 
          info.last["aggregate"]=nil
          temp = x.table_attribute.split('(').first
          info.last["aggregate"] = temp if agg.include?(temp)
        end  
      end
      info
    end 


    def information(id)
      reportobj =Report.find(id.to_i)
      info = {}  
      info["description"] = reportobj.description
      info["expected_values"] = []
      info["exposed_where_values"] = []
      info["exposed_having_values"] = []
      info["expected_values"] = selectinfo(reportobj)
      info["exposed_where_values"] = whereinfo(reportobj)
      info["exposed_having_values"] = havinginfo(reportobj,info)
      info
    end
  end
end