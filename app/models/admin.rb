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
    table =table.classify.constantize       # convert string to actual class  (Casting)
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
end