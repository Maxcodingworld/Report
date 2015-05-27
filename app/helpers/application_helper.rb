module ApplicationHelper
	def populate_list(table,attribute_to_show,attribute)
		options = {"Select"=>""}
		cities = table.classify.constantize.all
		cities.each {|st| options = options.merge({st["#{attribute}"] => st["#{attribute_to_show}"]})}
		options
	end
end
