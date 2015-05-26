class HomeController < ApplicationController
  layout "user_layout"
  def index
  	@reports = Report.all
  end

  def show_report
  end
end
