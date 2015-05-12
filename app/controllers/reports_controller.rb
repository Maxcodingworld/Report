class ReportsController < ApplicationController

	def new
	  @report = Report.new
	  @report.maintable = Maintable.new
	  @report.jointables << Jointable.new
	  @all_tables = Admin.tables_model_hash
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
end
