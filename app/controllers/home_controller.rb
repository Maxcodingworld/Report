class HomeController < ApplicationController
  layout "user_layout"
  def index
  	@reports = Report.all
  end

  def show_report
  	@report_data = Admin.information(params[:id])
  	data,total = Admin.retrive_data(params[:id],params["where"]||{},params["having"]||{},params[:page])
    @report_op = WillPaginate::Collection.create(params[:page] || 1, 10,total) do |pager|
      pager.replace(data)
    end
    # p @report_op
  end
end

