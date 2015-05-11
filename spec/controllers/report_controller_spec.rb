require 'rails_helper'

RSpec.describe ReportsController, :type => :controller do

	describe "controller spec" do
    context "create method" do  
	    it "if data is valid then it should save" do
	    	expect { post :create, :report => { description: "Testing" , invoke_times: 0 , maintable_attributes: {table: "etl_member_plans"}, jointables_attributes: [ { table1: "etl_member_plans" , table2: "etl_branches" , whichjoin: "INNER JOIN" }]}}.to change(Report,:count).by(1)
	      flash[:notice].should_not be_nil
        response.should redirect_to(reports_path)
      end

      it "If not valid values then should render new " do
        expect { post :create, :report => { description: "Testing" , invoke_times: 0 , jointables_attributes: [ { table1: "etl_member_plans" , table2: "etl_branches" , whichjoin: "INNER JOIN" }]}}.to change(Report,:count).by(0)
        flash[:notice].should be_nil
        response.should redirect_to(new_report_path)
      end
       
      it "should pass the parameter to the report object" do
        post :create, :report => { description: "Testing" , invoke_times: 0 , maintable_attributes: {table: "etl_member_plans"}, jointables_attributes: [ { table1: "etl_member_plans" , table2: "etl_branches" , whichjoin: "INNER JOIN" }]}
        assigns[:reportobj].should == Report.new[:report]
      end
    end
 
    context "new method" do
      it "should define a new object of report" do 
        get :new , :report => { description: "Testing" , invoke_times: 0 , maintable_attributes: {table: "etl_member_plans"}, jointables_attributes: [ { table1: "etl_member_plans" , table2: "etl_branches" , whichjoin: "INNER JOIN" }]}
        assigns[:reportobj].should == Report.new[:report]
      end
    end

    context "index method" do
      it "should get report id by params" do
        get :index , :id => '10001'
        assigns[:report_id] == '10001' 
      end
      
      it "should call the required report building function in model and get the result" do
        a ={}
        a[:report] = { description: "Testing" , invoke_times: 0 , maintable_attributes: {table: "etl_member_plans"}, jointables_attributes: [ { table1: "etl_member_plans" , table2: "etl_branches" , whichjoin: "INNER JOIN" }]}
        reportobj=Report.new(a[:report])
        expect{ reportobj.save }.to change(Report, :count).by(1)
        get :index , :id => reportobj.id
        assigns[:report_id] == reportobj.id 
        assigns[:result].class == ActiveRecord::Relation
      end
    end
  
  end
end

