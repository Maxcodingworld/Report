class OrderReport < ActiveRecord::Base

set_table_name 'temp2ibtrves'


	def self.result(fromdate,todate)
		
         
        conditions=[]
        conditions[0]='' 

        if fromdate
        	fromdate=fromdate.to_time.to_i
            conditions[0] << "created_at_int >= ? "
            conditions << fromdate
        end
       
        if todate
        	todate=todate.to_time.to_i
            conditions[0] << "and created_at_int <= ? "
            conditions << todate
        end
                        
        obj=OrderReport.where(conditions)


		states = obj.select("Flag_Destination,State,Count(*) As Num").group("Flag_Destination,State").order("State")
       # p states[0].state

        
        missing_books_D = obj.select("1").where("book_state = 1 and flag_destination = 'D'").group("ibtr_id")
       # p missing_books.length
        missing_books_S = obj.select("1").where("book_state = 1 and flag_destination = 'S'").group("ibtr_id")
         

        cancelled_by_member =obj.select("count(*) as cancelled_by_member").where("state = 'Cancelled' and created_by = 13190")
        cancelled_by_ops =obj.select("count(*) as cancelled_by_ops").where("state = 'Cancelled' and created_by != 13190")
      # p cancelled_by_member[0]["cancelled_by_member"]
      # p cancelled_by_ops[0]["cancelled_by_ops"]



        fulfilled_in_n_days =  obj.select("count(*) as fulfilled_in_n_days,ceil((updated_at_int - created_at_int)/(3600*24)) as days,Flag_Destination ").where("state = 'Fulfilled'").group("ceil((updated_at_int - created_at_int)/(3600*24)),Flag_Destination")
      # p fulfilled_in_1day[0].days  
     


        result = {}

        result["states"] = states
        result["missing_books_D"] = missing_books_D.length
        result["missing_books_S"] = missing_books_S.length
        result["cancelled_by_member"] = cancelled_by_member[0]["cancelled_by_member"]
        result["cancelled_by_ops"] = cancelled_by_ops[0]["cancelled_by_ops"]
        result["fulfilled_in_n_days"] = fulfilled_in_n_days


        result          

	end


end