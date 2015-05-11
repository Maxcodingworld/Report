class ReportsController < ApplicationController

	def new
	  @reportobj = Report.new[params[:report]]
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
    #result = Admin.retrive_data(params[:id])
	end

end
