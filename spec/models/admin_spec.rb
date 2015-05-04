require 'rails_helper'

describe Admin do 
	context "Join Module" do
        it "joinstring should return respective string to join two tables for flag = 1" do 
        	Admin.joinstring("etl_member_plans","etl_branches","INNER JOIN",1).should eq(" INNER JOIN etl_branches on etl_member_plans.branch_id = etl_branches.id")  	    	 
  	    end
    
        it "joinstring should return respective string to join two tables for flag = 2" do 
        	Admin.joinstring("etl_member_plans","etl_branches","INNER JOIN",2).should eq(", etl_member_plans INNER JOIN etl_branches on etl_member_plans.branch_id = etl_branches.id")  	    	 
  	    end
        
        it "joinstring should return error if table name doesnot exist" do 
        	expect { Admin.joinstring("a","etl_branches","INNER JOIN",1)}.to raise_error	    	 
  	    end
    
        it "joinstring should return error if association doesnot exist between tables" do 
        	expect { Admin.joinstring("etl_plans","etl_branches","INNER JOIN",1)}.to raise_error	    	 
  	    end  

        it "join_order_operation should return the joined table accordingly" do
        	a = { report: { description: "Testing" , invoke_times: 0 , jointables_attributes: [ { table1: "etl_member_plans" , table2: "etl_branches" , whichjoin: "INNER JOIN" }]}}
        	reportobj = Report.new(a[:report])
        	reportobj.save
            query1 = Admin.join_order_operation(reportobj).collect(&:id) 
            query2 = EtlMemberPlan.joins(:etl_branch).collect(&:id)
            
            (query1 - query2).should == []
            (query2 - query1).should == []
        end
    end

    context "where Module" do
        it "where_operation should return the required output" do 
        	a = { report: { description: "Testing_where" , invoke_times: 0 , wheretables_attributes: [ { table_attribute: "etl_member_plans.branch_id" , r_operator: ">=" , value: "25" , expo_default_flag: "0" }], jointables_attributes: [ { table1: "etl_member_plans" , table2: "etl_branches" , whichjoin: "INNER JOIN" }]}}
            reportobj = Report.new(a[:report])
        	reportobj.save
            query1 = Admin.where_operation(Admin.join_order_operation(reportobj),reportobj).collect(&:id) 
            query2 = EtlMemberPlan.joins(:etl_branch).where("etl_member_plans.branch_id >= 25").collect(&:id)
            (query1 - query2).should == []
            (query2 - query1).should == []
        end
    
        it "if where string is null , where_operation should return the same output as input" do
        	a = { report: { description: "Testing_where" , invoke_times: 0 , jointables_attributes: [ { table1: "etl_member_plans" , table2: "etl_branches" , whichjoin: "INNER JOIN" }]}}
            reportobj = Report.new(a[:report])
        	reportobj.save
            query1 = Admin.where_operation(Admin.join_order_operation(reportobj),reportobj).collect(&:id) 
            query2 = EtlMemberPlan.joins(:etl_branch).collect(&:id)
            (query1 - query2).should == []
            (query2 - query1).should == []
        end
    end

    # context "group having Module" do
    #     it "group_having_operations should return the required output" do 
    #     	a = { report: { description: "Testing_where" , invoke_times: 0 , wheretables_attributes: [ { table_attribute: "etl_member_plans.branch_id" , r_operator: ">=" , value: "25" , expo_default_flag: "0" }], jointables_attributes: [ { table1: "etl_member_plans" , table2: "etl_branches" , whichjoin: "INNER JOIN" }]}}
    #         reportobj = Report.new(a[:report])
    #     	reportobj.save
    #         query1 = Admin.where_operation(Admin.join_order_operation(reportobj),reportobj).collect(&:id) 
    #         query2 = EtlMemberPlan.joins(:etl_branch).where("etl_member_plans.branch_id >= 25").collect(&:id)
    #         (query1 - query2).should == []
    #         (query2 - query1).should == []
    #     end
    
    #     it "if where string is null , where_operation should return the same output as input" do
    #     	a = { report: { description: "Testing_where" , invoke_times: 0 , jointables_attributes: [ { table1: "etl_member_plans" , table2: "etl_branches" , whichjoin: "INNER JOIN" }]}}
    #         reportobj = Report.new(a[:report])
    #     	reportobj.save
    #         query1 = Admin.where_operation(Admin.join_order_operation(reportobj),reportobj).collect(&:id) 
    #         query2 = EtlMemberPlan.joins(:etl_branch).collect(&:id)
    #         (query1 - query2).should == []
    #         (query2 - query1).should == []
    #     end
    # end





end	    