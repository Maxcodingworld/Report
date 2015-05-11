require 'rails_helper'

describe Admin do 
    context "Maintable Module" do
        it "maintable should not be empty for a particular report otherwise should raise error" do
            a = { report: { description: "Testing" , invoke_times: 0 }}
            reportobj = Report.new(a[:report])
            expect {reportobj.save }.to change(Report, :count).by(0)
        end

        it "maintable should be exist in same application" do
            a = { report: { description: "Testing" , invoke_times: 0 , maintable_attributes:{table: "etl"}}}
            reportobj = Report.new(a[:report])
            expect {reportobj.save }.to change(Report, :count).by(0)
        end
    end


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
        	a = { report: { description: "Testing" , invoke_times: 0 , maintable_attributes: {table: "etl_member_plans"}, jointables_attributes: [ { table1: "etl_member_plans" , table2: "etl_branches" , whichjoin: "INNER JOIN" }]}}
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
        	a = { report: { description: "Testing_where" , invoke_times: 0 , maintable_attributes: {table: "etl_member_plans"}, wheretables_attributes: [ { table_attribute: "etl_member_plans.branch_id" , r_operator: ">=" , value: "25" , expo_default_flag: "0" }], jointables_attributes: [ { table1: "etl_member_plans" , table2: "etl_branches" , whichjoin: "INNER JOIN" }]}}
            reportobj = Report.new(a[:report])
        	reportobj.save!
            query1 = Admin.where_operation(Admin.join_order_operation(reportobj),reportobj).collect(&:id) 
            query2 = EtlMemberPlan.joins(:etl_branch).where("etl_member_plans.branch_id >= 25").collect(&:id)
            (query1 - query2).should == []
            (query2 - query1).should == []
        end
    
        it "if where string is null , where_operation should return the same output as input" do
        	a = { report: { description: "Testing_where" , invoke_times: 0 , maintable_attributes: {table: "etl_member_plans"}, jointables_attributes: [ { table1: "etl_member_plans" , table2: "etl_branches" , whichjoin: "INNER JOIN" }]}}
            reportobj = Report.new(a[:report])
        	reportobj.save!
            query1 = Admin.where_operation(Admin.join_order_operation(reportobj),reportobj).collect(&:id) 
            query2 = EtlMemberPlan.joins(:etl_branch).collect(&:id)
            (query1 - query2).should == []
            (query2 - query1).should == []
        end
    end

    context "group having Module" do
        it "group_having_operations should return the required output" do 
        	a = { report: { description: "Testing_group_having" , invoke_times: 0 , maintable_attributes: {table: "etl_member_plans"}, havingtables_attributes: [ { table_attribute: "etl_member_plans.branch_id" , r_operator: ">=" , value: "25" , expo_default_flag: "0" }], grouptables_attributes: [ { table_attribute: "etl_member_plans.branch_id" }]}}
            reportobj = Report.new(a[:report])
        	reportobj.save
            query1 = Admin.group_having_operations(EtlMemberPlan.select("min(id)"),reportobj).collect(&:id) 
            query2 = EtlMemberPlan.select("min(id)").group("branch_id").having("etl_member_plans.branch_id >= 25").collect(&:id)
            (query1 - query2).should == []
            (query2 - query1).should == []
        end
    
        it "if group string is null and having string is not null,save! should return error" do
        	a = { report: { description: "Testing_group_having" , invoke_times: 0 , havingtables_attributes: [ { table_attribute: "etl_member_plans.branch_id" , r_operator: ">=" , value: "25" , expo_default_flag: "0" }]}}
            reportobj = Report.new(a[:report])
        	expect {reportobj.save }.to change(Report, :count).by(0)
            #expect { Admin.group_having_operations(EtlMemberPlan.select("min(id)"),reportobj).collect(&:id) }.to raise_error 
            
        end
    
        it "if group string is not null and select string is nil,save! should return error" do
            a = { report: { description: "Testing_group_having" , invoke_times: 0 , grouptables_attributes: [ { table_attribute: "etl_member_plans.branch_id" }]}}
            reportobj = Report.new(a[:report])
            expect {reportobj.save }.to change(Report, :count).by(0)
            # expect { Admin.group_having_operations(EtlMemberPlan,reportobj).collect(&:id) }.to raise_error 
            
        end
        
        it "if group string is not empty then select string should either contain the group specified attribute or attribute with aggregate function otherwise save! should raise error" do
            a = { report: { description: "Testing_group_having" , invoke_times: 0 ,selecttables_attributes:[{table_attribute: "etl_member_plans.id"}] ,grouptables_attributes: [ { table_attribute: "etl_member_plans.branch_id" }]}}
            reportobj = Report.new(a[:report])
            expect {reportobj.save }.to change(Report, :count).by(0)
        end

    end


    context "select Module" do
        it "select_operation should return the required output" do 
            a = { report: { description: "Testing_select" , invoke_times: 0 , maintable_attributes: {table: "etl_member_plans"} , selecttables_attributes: [ { table_attribute: "etl_member_plans.id" }]}}
            reportobj = Report.new(a[:report])
            reportobj.save
            query1 = Admin.select_operation(EtlMemberPlan,reportobj).collect(&:id) 
            query2 = EtlMemberPlan.select("id").collect(&:id)
            (query1 - query2).should == []
            (query2 - query1).should == []
        end
    
        it "if select string is empty , it should return the output as same as input" do 
            a = { report: { description: "Testing_select" , invoke_times: 0 , maintable_attributes: {table: "etl_member_plans"}}}
            reportobj = Report.new(a[:report])
            reportobj.save
            query1 = Admin.select_operation(EtlMemberPlan,reportobj).collect(&:id) 
            query2 = EtlMemberPlan.select("*").collect(&:id)
            (query1 - query2).should == []
            (query2 - query1).should == []
        end
    end

    context "validity of attribute" do
        it "all attributes in select table should be contained in selected tables attribute set otherwise error" do
            Rails.application.eager_load!
            a = { report: { description: "Testing_select" , invoke_times: 0 , selecttables_attributes: [ { table_attribute: "etl_member_plans.noattribute" }] , maintable_attributes: {table: "etl_member_plans"} , jointables_attributes: [ { table1: "etl_member_plans" , table2: "etl_branches" , whichjoin: "INNER JOIN" }] }}
            reportobj = Report.new(a[:report])
            expect {reportobj.save }.to change(Report, :count).by(0)
        end
        it "all attributes in where table should be contained in selected tables attribute set otherwise error" do
            a = { report: { description: "Testing_where" , invoke_times: 0 , wheretables_attributes: [ { table_attribute: "etl_member_plans.noattribute" , r_operator: ">=" , value: "25" , expo_default_flag: "0" }], maintable_attributes: {table: "etl_member_plans"} , jointables_attributes: [ { table1: "etl_member_plans" , table2: "etl_branches" , whichjoin: "INNER JOIN" }]}}
            reportobj = Report.new(a[:report])
            expect {reportobj.save }.to change(Report, :count).by(0)
        end    

        it "all attributes in group table should be contained in selected tables attribute set otherwise error" do
            a = { report: { description: "Testing_group_having" , invoke_times: 0 , grouptables_attributes: [ { table_attribute: "etl_member_plans.noattribute" }] , maintable_attributes: {table: "etl_member_plans"} , jointables_attributes: [ { table1: "etl_member_plans" , table2: "etl_branches" , whichjoin: "INNER JOIN" }] }}
            reportobj = Report.new(a[:report])
            expect {reportobj.save }.to change(Report, :count).by(0)
        end

        it "all attributes in having table should be contained in selected tables attribute set otherwise error" do
            a = { report: { description: "Testing_group_having" , invoke_times: 0 , havingtables_attributes: [ { table_attribute: "etl_member_plans.noattribute" , r_operator: ">=" , value: "25" , expo_default_flag: "0" }] , maintable_attributes: {table: "etl_member_plans"} , jointables_attributes: [ { table1: "etl_member_plans" , table2: "etl_branches" , whichjoin: "INNER JOIN" }]}}
            reportobj = Report.new(a[:report])
            expect {reportobj.save }.to change(Report, :count).by(0)
        end

        it "all attributes in order table should be contained in selected tables attribute set otherwise error" do
            a = { report: { description: "Testing_group_having" , invoke_times: 0 , ordertables_attributes: [ { table_attribute: "etl_member_plans.noattribute",desc_asce: "DESC" , expo_default_flag: "0" }] , maintable_attributes: {table: "etl_member_plans"} , jointables_attributes: [ { table1: "etl_member_plans" , table2: "etl_branches" , whichjoin: "INNER JOIN" }]}}
            reportobj = Report.new(a[:report])
            expect {reportobj.save }.to change(Report, :count).by(0)
        end
    end
end	    