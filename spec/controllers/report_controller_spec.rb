require 'rails_helper'

RSpec.describe ReportsController, :type => :controller do

	describe "controller spec" do
    context "create method" do  
	    it "if data is valid then it should save" do
	    	expect{
	    	post :create, :report => { description: "Testing" , invoke_times: 0 , jointables_attributes: [ { table1: "etl_member_plans" , table2: "etl_branches" , whichjoin: "INNER JOIN" }]}}}.to change(Report,:count).by(1)
	    end

      it "If not valid values then should not save and render new " do
      end
    
      context "saving should insert proper rows into proper tables" do
        it "jointable" do
        end   
         
        it "wheretable" do
        end
      
      # ...  
      end      
    end 
    
    context "new method" do
      it "should define a new object of report" do 
      end
    end

    context "index method" do
      it "should get report id by params" do
      end
      
      it "should call the required report building function in model and get the result" do
      end
      
      it "should pass the resulting array to view" do
      end
    end
  end
end

