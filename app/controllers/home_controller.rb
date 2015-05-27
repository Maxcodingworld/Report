class HomeController < ApplicationController
  layout "user_layout"
  def index
  	@reports = Report.all
  end

  def show_report
  	@report_data = {"description" => "Branch Circulation Report", 
  		"expected_values" => ["name"],
  		"exposed_where_values" => [
        {
      		"table" => "etl_circulations", "attribute" => "branch_id", "label" => "Branch", "which_table" => "etl_branches", "which_field_to_show" => "name", "which_field" => "id"
      	},
        {
          "table" => "etl_circulations", "attribute" => "plan_id", "label" => "Plan", "which_table" => "etl_plans", "which_field_to_show" => "name", "which_field" => "id"
        },
        {
          "table" => "etl_circulations", "attribute" => "membership_no", "label" => "Membership No"
        }
      ],
      "exposed_having_values" => [{
          "table" => "etl_circulations", "attribute" => "issue_branch_id", "label" => "Branch Issued More than * books"
        }]
    }#Admin.information(params[:id])
  	@report_op = [{"name" => 'pollo'},{"name" => 'josh'}]#Admin.retrive_data(params[:id],params["where"]||{},params["having"]||{})
  end
end
