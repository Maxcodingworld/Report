class ReportsController < ApplicationController

	def new
	  @report = Report.new
	  @report.maintable = Maintable.new
	  @all_tables = Admin.tables_model_hash.keys
   	end


	def create
		reportobj = Report.new(params[:report])
			if reportobj.save!
				flash[:notice] = "Report successfully saved"
				redirect_to reports_path
			else
				redirect_to(new_report_path)
			end
	end

	def index
    # report_id = params[:id]
    # result = Admin.retrive_data(params[:id])
    redirect_to home_path
	end

	def show
		render :json =>Admin.retrive_data(params[:id],params["where"]||{},params["having"]||{})
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
