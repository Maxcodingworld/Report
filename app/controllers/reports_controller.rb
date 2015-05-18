class ReportsController < ApplicationController

	def new
	  @report = Report.new
	  @report.maintable = Maintable.new
	  @report.jointables << Jointable.new
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
	  @table_name=params[:table_name]
	  options = '<option value="" disabled>Associated table</option>'
	  categories = Admin.all_associations(params[:table_name])
	  categories.each do |cat|
	  	if (cat[1].present?)
	  	 options << "<optgroup label=#{cat[0]}><u>#{cat[0]}:</u></option>"
	  	 cat[1].each do |x|
	  	 	p x.to_s.pluralize
		  	options << "<option value=#{x.to_s.pluralize}>#{x}</option>"
		 end 	 
	    end
	  end
	  render :text => options
	end
end
