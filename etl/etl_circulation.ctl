class EtlCirculation < ActiveRecord::Base
  establish_connection "etl_execution"
  self.table_name =  'etl_circulations'
end

  d= 0

  if !EtlCirculation.first
    d = 0
  else
    d = EtlCirculation.connection.execute("SELECT MAX(ID) FROM ETL_CIRCULATIONS").fetch[0].to_i
  end
 
 source :input,
  {
  :type => :database,
  :target => :development,
  :table => "etl_returns",
  :join =>"inner join etl_titles on etl_returns.title_id = etl_titles.id inner join etl_member_plans on etl_returns.member_plan_id = etl_member_plans.id inner join etl_authors on etl_titles.author_id = etl_authors.id inner join etl_categories on etl_titles.category_id = etl_categories.id ",
  :select => "etl_returns.id as id ,member_plan_id as m_p_i ,branch_id , plan_id,member_profile_id,issue_date ,return_date ,issue_branch_id ,title_id as t_id,created_at,updated_at,rent_duration, etl_authors.name as a_name,author_id,category_type,etl_categories.name as category_name",
  :conditions => "etl_returns.id > #{d} "
  },
  [
    :m_p_i,
    :issue_date,
    :return_date,
    :issue_branch_id,
    :t_id,
    :created_at,
    :updated_at,
    :rent_duration,
    :a_name,
    :author_id,
    :category_type,
    :category_name,
    :branch_id,
    :plan_id,
    :member_profile_id
  ]

transform(:member_plan_id) do |n,v,r|
  r[:m_p_i].to_i
end

transform(:issue_date) do |n,v,r|
  r[:issue_date].to_date
end

transform(:plan_id) do |n,v,r|
  r[:plan_id].to_i
end

transform(:branch_id) do |n,v,r|
  r[:branch_id].to_i
end

transform(:member_profile_id) do |n,v,r|
  r[:member_profile_id].to_i
end

transform(:return_date) do |n,v,r|
  r[:return_date].to_date
end

transform(:issue_branch_id) do |n,v,r|
  r[:issue_branch_id].to_i
end

transform(:title_id) do |n,v,r|
  r[:t_id].to_i
end

transform(:created_at) do |n,v,r|
  r[:created_at].to_date
end

transform(:updated_at) do |n,v,r|
  r[:updated_at].to_date
end

transform(:rent_duration) do |n,v,r|
  r[:rent_duration].to_i
end

transform(:created_at_in_second) do |n,v,r|
    r[:created_at].to_time.to_i
end

transform(:updated_at_in_second) do |n,v,r|
  r[:updated_at].to_time.to_i
end

transform(:author_id) do |n,v,r|
  r[:author_id].to_i
end

transform(:author_name) do |n,v,r|
  r[:a_name]
end

transform(:category_name) do |n,v,r|
  r[:category_name]
end

transform(:category_type) do |n,v,r|
  r[:category_type]
end


destination :out, {
  :type => :database,
  :target => :etl_execution,
  :table => "etl_circulations"
},
{
  :primarykey => [:id],
  :order =>[:id,:member_plan_id,:issue_date,:return_date,:issue_branch_id,:member_profile_id,:title_id,:branch_id,:plan_id,:created_at,:updated_at,:rent_duration,:created_at_in_second,:updated_at_in_second,:author_id,:author_name,:category_type,:category_name]
} 




