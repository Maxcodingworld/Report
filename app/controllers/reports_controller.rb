class ReportsController < ApplicationController

	def new
	  @report = Report.new
	  @report.maintable = Maintable.new
	  @all_tables = Admin.tables_model_hash.keys
  end

  def create_join
  	@reportjoinobj = Report.new(params[:report])
  	if @reportjoinobj.save!
				flash[:notice] = "Report successfully saved"
				redirect_to operation_reports_path(@reportjoinobj.id)
			else
				redirect_to(new_report_path)
			end
  end

  def operation
  	@arr = []
  	@option = []
  	 a = params
  	 @arr << Report.find_by_id(a["format"].to_i).maintable.table
  	 Report.find_by_id(a["format"].to_i).jointables.each do |x|
  	 			@arr << x.table1
  	 			@arr << x.table2
  	 end
  	 @arr = @arr.uniq
	  	 @arr.each do |x|
  	 	 @option << [x,x] 
		   categories = Admin.all_attributes(x)
		   categories.each do |cat|
				 @option << [cat,x+"."+cat]
		   end
		end
 	  @reportjoinobj = Report.new()
 	  
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
    report_id = params[:id]
    result = Admin.retrive_data(params[:id])
	end

	# def show
	# 	# render :json =>Admin.retrive_data(params[:id])
	# end
	
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

	def moreoperation
		@optables = params[:optables]
	end
end
