class OrderReportsController < ApplicationController

	def filter
	end

	def result
		@dates = params[:dates]	
		@fromdate=(@dates["fromdate(3i)"] + '-' +@dates["fromdate(2i)"] + '-' + @dates["fromdate(1i)"]).to_time
		@todate=(@dates["todate(3i)"] + '-' +@dates["todate(2i)"] + '-' + @dates["todate(1i)"]).to_time
		@result=OrderReport.result(@fromdate,@todate)
		@states = @result["states"]
		@fulfilled_in_n_days = @result["fulfilled_in_n_days"]
	end

	def choose
	end
end