class ReportsController < ApplicationController

	def new
	  @report = Report.new
	  @report.maintable = Maintable.new
	  # @report.jointables << Jointable.new
	  @all_tables = Admin.tables_model_hash
	  # @all_associations = Admin.all_associations(table)
   	end

	def create
		reportobj = Report.new(params[:report])
			if reportobj.save
				flash[:notice] = "Report successfully saved"
				redirect_to reports_path
			else
				redirect_to(new_report_path)
			end
	end

	def index
    report_id = params[:id]
    result = Admin.retrive_data(params[:id])
	end

	def show
	end
	
	def association
	  options = '<option value="">Associated table</option>'
	  categories = Admin.all_associations(params[:table_name])
	  categories.each do |cat|
	  	if (cat[1].present?)
	  	 options << "<optgroup label=#{cat[0]}><u>#{cat[0]}:</u></option>"
	  	 cat[1].each do |x|
	  	 	 x.to_s.pluralize
		  	options << "<option value=#{x.to_s.pluralize}>#{x}</option>"
		 end 	 
	    end
	  end
	  render :text => options
	end

	def attributes
	    options = '<option value="">attributes</option>'
	    params[:table_name].split(",").each do |x|
		   categories = Admin.all_attributes(x)
		   options << "<optgroup label=#{x}><u>#{x}:</u></option>"
		   categories.each do |cat|
			 options << "<option value=#{x + "." + cat}>#{cat}</option>"
		   end
		end
		render :text => options
	end

end
