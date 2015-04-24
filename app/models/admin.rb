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
  	Rails.application.eager_load!           # Loads full application
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
               
  def self.build_query(table1,table2,order,which_join) #table1= model_name , table2=association_name
    table1=table1.classify.constantize
    stage1=Class.new
    if table2.empty?
      stage1=table1.order(order)
    else 
      if which_join == 'LEFT OUTER JOIN'
        stage1=table1.includes(:"#{table2}").order(order)           
      elsif which_join == 'RIGHT OUTER JOIN'
        temp =table1.reflections[:"#{table2}"]
        table2=temp.plural_name    
        attrr= temp.options[:foreign_key]
        if temp.macro == :has_many 
          stage1=table1.joins("RIGHT OUTER JOIN #{table2} on #{table1.table_name}.id = #{table2}.#{attrr}").order(order)
        elsif temp.macro == :belongs_to
          stage1=table1.joins("RIGHT OUTER JOIN #{table2} on #{table1.table_name}.#{attrr} = #{table2}.id").order(order)
        end
      else
        stage1=table1.joins(:"#{table2}").order(order)
      end 
    end
  stage1
  end

end