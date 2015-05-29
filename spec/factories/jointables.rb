FactoryGirl.define do
  factory :jointable do
    report_id 1
table1 "etl_member_plans" 
table2 "etl_branches"
whichjoin "INNER JOIN"
created_at Date.today          
updated_at Date.today   
  end

end
