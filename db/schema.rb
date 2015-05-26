# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20150505095550) do

  create_table "etl_authors", :force => true do |t|
    t.string "name"
  end

  create_table "etl_branches", :force => true do |t|
    t.string "name"
    t.string "category"
  end

  create_table "etl_categories", :force => true do |t|
    t.string "name"
    t.string "category_type"
  end

  create_table "etl_circulations", :force => true do |t|
    t.integer  "member_plan_id"
    t.integer  "title_id"
    t.date     "issue_date"
    t.date     "return_date"
    t.integer  "rent_duration"
    t.integer  "issue_branch_id"
    t.integer  "created_at_in_second"
    t.integer  "updated_at_in_second"
    t.integer  "author_id"
    t.string   "category_type"
    t.string   "category_name"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
    t.string   "author_name"
    t.integer  "plan_id"
    t.integer  "branch_id"
    t.integer  "member_profile_id"
  end

  create_table "etl_infos", :force => true do |t|
    t.string   "table_name"
    t.integer  "last_etl_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "etl_member_plans", :force => true do |t|
    t.integer "branch_id"
    t.integer "plan_id"
    t.integer "member_profile_id"
  end

  create_table "etl_member_profile_infos", :force => true do |t|
    t.string "email"
    t.string "name"
  end

  create_table "etl_plans", :force => true do |t|
    t.string "name"
  end

  create_table "etl_returns", :force => true do |t|
    t.integer  "member_plan_id"
    t.date     "issue_date"
    t.date     "return_date"
    t.integer  "rent_duration"
    t.integer  "issue_branch_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.integer  "title_id"
    t.date     "custom"
  end

  create_table "grouptables", :force => true do |t|
    t.integer  "report_id"
    t.string   "table_attribute"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "havingtables", :force => true do |t|
    t.integer  "report_id"
    t.string   "table_attribute"
    t.string   "r_operator"
    t.string   "value"
    t.string   "expo_default_flag"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  create_table "jointables", :force => true do |t|
    t.integer  "report_id"
    t.string   "table1"
    t.string   "table2"
    t.string   "whichjoin"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "maintables", :force => true do |t|
    t.integer  "report_id"
    t.string   "table"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "mem_reports", :force => true do |t|
    t.integer  "branch_id"
    t.integer  "plan_id"
    t.integer  "to_book"
    t.integer  "from_book"
    t.date     "to_date"
    t.date     "from_date"
    t.string   "day_limit"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "ordertables", :force => true do |t|
    t.integer  "report_id"
    t.string   "table_attribute"
    t.string   "desc_asce"
    t.string   "expo_default_flag"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  create_table "reports", :force => true do |t|
    t.string   "description"
    t.integer  "invoke_times"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "selecttables", :force => true do |t|
    t.integer  "report_id"
    t.string   "table_attribute"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "wheretables", :force => true do |t|
    t.integer  "report_id"
    t.string   "table_attribute"
    t.string   "r_operator"
    t.string   "value"
    t.string   "expo_default_flag"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

end
