class MemReportsController < ApplicationController

require 'will_paginate/array'
	def new
	   	@mbook_report = MemReport.new
	  end
	  
	  def create
		 @mbook_report = MemReport.create(params[:mem_report])
	  	if @mbook_report.save
	    	redirect_to mem_report_path(:id => @mbook_report.id)
	    else
	      render :action => 'new'
	    end
	  end

	  def show
	  	 @filter = MemReport.find(params[:id])
	  	 @rep = @filter.find_members().paginate :page => (params[:page].blank? ? 1 : params[:page]), :per_page => (params[:per_page] ||20)
	  end

	  def bookdetail
	  	  @bdetail = MemReport.find(params["filter_id"]).book_details(params["id"].to_i)
	  end

	  
end
