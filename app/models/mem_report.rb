class MemReport < ActiveRecord::Base
  attr_accessible :branch_id, :day_limit, :from_book, :from_date, :plan_id, :to_book, :to_date


	def find_members()
	    member_plans = []
	    m_cdn = []
	    m_cdn[0] = ""
	    	if branch_id.present?
	    		m_cdn[0] << "branch_id = ? and"
	    		m_cdn <<  branch_id
	    	end	 
		    if plan_id.present? 
		    	m_cdn[0] << " plan_id = ? and"
		    	m_cdn <<  plan_id
		    end
		    if day_limit == "custom"
		    	m_cdn[0] << " issue_date >= ? and issue_date <= ?"
                m_cdn << from_date 
                m_cdn << to_date 
            end     
		    if day_limit == "oneweek"
		    	m_cdn[0] << " issue_date >= ?"
		    	m_cdn << Time.zone.today-1.week
		   	end
		   	if day_limit == "onemonth"
		    	m_cdn[0] << " issue_date >= ?"
		    	m_cdn << Time.zone.today-6.year
		   	end	
        

		    	 
		    	# m_cdn[0] << " cast(count_m_plan_id_in_return as int) > = ? and"
		    	# m_cdn <<  from_book
		    	# m_cdn[0] << " cast(count_m_plan_id_in_return as int) < = ?"
		    	# m_cdn <<  to_book
		    	
		     member_plans =  EtlCirculation.select('member_plan_id, min(branch_id) as b_id, count(*) as tot , min(plan_id) as p_id , min(member_profile_id) as m_p_id').where(m_cdn).group(:member_plan_id).having("count(1) >= ? and count(1) <= ? ", from_book,to_book) 
		      member_plans
	end


	def book_details(a)
		book_detail = [] 
	    m_cdn = []
	    m_cdn[0] = ""
	    	m_cdn[0] << "member_plan_id =  ? and"
	    	m_cdn << a
	    	if day_limit == "custom"
		    	m_cdn[0] << " issue_date >= ? and issue_date <= ?"
                m_cdn << from_date 
                m_cdn << to_date 
            end     
		    if day_limit == "oneweek"
		    	m_cdn[0] << " issue_date >= ?"
		    	m_cdn << Time.zone.today-1.week
		   	end
		   	if day_limit == "onemonth"
		    	m_cdn[0] << " issue_date >= ?"
		    	m_cdn << Time.zone.today-6.year
		   	end	

			  book_details =  EtlCirculation.where(m_cdn)
		      book_details

	end

end
