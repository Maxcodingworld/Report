class HomeController < ApplicationController
  layout "user_layout"
  def index
  	@reports = Report.all
  end

  def show_report
  	@report_data = Admin.information(params[:id])
  	p params[:id]
  	p params["where"]||{}
  	p params["having"]||{}
  	@report_op = Admin.retrive_data(params[:id],params["where"]||{},params["having"]||{})
    p @report_op
  end
end

