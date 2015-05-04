class Admin < ActiveRecord::Base
  def self.all_tables	
			Rails.application.eager_load!  	
  		ActiveRecord::Base.descendants
  end

  def self.operations(table1,table2)
   	table1 = table1.classify.constantize
   	table1.joins(:"#{table2}").first
  end

  def self.selectop(table,*args)
  	table = table.classify.constantize
  	if args[0] == "All"
  		args[0] = "*"
  	end	
  	 	table.select( "#{args.join(', ')}")
  end

  def self.group_having_order(table)
  
  end

end