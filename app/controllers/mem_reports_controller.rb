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
	  	 @mb = MemReport.find(params[:id])
	  	 @rep = @mb.find_members().paginate :page => (params[:page].blank? ? 1 : params[:page]), :per_page => (params[:per_page] ||20)
	  end

	  def bookdetail
	  	  @f = MemReport.find(params["filter_id"])
	  	  p @f

	  	  @m = params["id"].to_i
	  	  p @m
	  	  @a = @f.book_details(@m)
	  	   
	  end

	  
end
