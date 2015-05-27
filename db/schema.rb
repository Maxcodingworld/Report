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

ActiveRecord::Schema.define(:version => 20150527103842) do

  create_table "batches", :force => true do |t|
    t.string   "batch_file",   :null => false
    t.datetime "created_at",   :null => false
    t.datetime "completed_at"
    t.string   "status"
  end

  create_table "etl_authors", :force => true do |t|
    t.string "name"
  end

  create_table "etl_books", :force => true do |t|
    t.string "state"
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
    t.integer  "member_plan_id",       :precision => 38, :scale => 0
    t.integer  "title_id",             :precision => 38, :scale => 0
    t.datetime "issue_date"
    t.datetime "return_date"
    t.integer  "rent_duration",        :precision => 38, :scale => 0
    t.integer  "issue_branch_id",      :precision => 38, :scale => 0
    t.integer  "created_at_in_second", :precision => 38, :scale => 0
    t.integer  "updated_at_in_second", :precision => 38, :scale => 0
    t.integer  "author_id",            :precision => 38, :scale => 0
    t.string   "category_type"
    t.string   "category_name"
    t.datetime "created_at",                                          :null => false
    t.datetime "updated_at",                                          :null => false
    t.string   "author_name"
    t.integer  "plan_id",              :precision => 38, :scale => 0
    t.integer  "branch_id",            :precision => 38, :scale => 0
    t.integer  "member_profile_id",    :precision => 38, :scale => 0
  end

  create_table "etl_ibtr_versions", :force => true do |t|
    t.integer  "ibtr_id",          :precision => 38, :scale => 0
    t.string   "state"
    t.integer  "created_by",       :precision => 38, :scale => 0
    t.integer  "created_at_int",   :precision => 38, :scale => 0
    t.integer  "updated_at_int",   :precision => 38, :scale => 0
    t.string   "flag_destination"
    t.integer  "book_id",          :precision => 38, :scale => 0
    t.datetime "created_at_date"
    t.datetime "updated_at_date"
  end

  create_table "etl_infos", :force => true do |t|
    t.string   "table_name"
    t.integer  "last_etl_id", :precision => 38, :scale => 0
    t.datetime "created_at",                                 :null => false
    t.datetime "updated_at",                                 :null => false
  end

  create_table "etl_member_plans", :force => true do |t|
    t.integer "branch_id",         :precision => 38, :scale => 0
    t.integer "plan_id",           :precision => 38, :scale => 0
    t.integer "member_profile_id", :precision => 38, :scale => 0
  end

  create_table "etl_member_profile_infos", :force => true do |t|
    t.string "email"
    t.string "name"
  end

  create_table "etl_plans", :force => true do |t|
    t.string "name"
  end

  create_table "etl_returns", :force => true do |t|
    t.integer  "member_plan_id",  :precision => 38, :scale => 0
    t.datetime "issue_date"
    t.datetime "return_date"
    t.integer  "rent_duration",   :precision => 38, :scale => 0
    t.integer  "issue_branch_id", :precision => 38, :scale => 0
    t.datetime "created_at",                                     :null => false
    t.datetime "updated_at",                                     :null => false
    t.integer  "title_id",        :precision => 38, :scale => 0
    t.datetime "custom"
  end

  create_table "etl_titles", :force => true do |t|
    t.string  "title"
    t.integer "author_id",   :precision => 38, :scale => 0
    t.integer "category_id", :precision => 38, :scale => 0
  end

  create_table "grouptables", :force => true do |t|
    t.integer  "report_id",       :precision => 38, :scale => 0
    t.string   "table_attribute"
    t.datetime "created_at",                                     :null => false
    t.datetime "updated_at",                                     :null => false
  end

  create_table "havingtables", :force => true do |t|
    t.integer  "report_id",           :precision => 38, :scale => 0
    t.string   "table_attribute"
    t.string   "r_operator"
    t.string   "value"
    t.string   "expo_default_flag"
    t.datetime "created_at",                                         :null => false
    t.datetime "updated_at",                                         :null => false
    t.string   "which_table"
    t.string   "which_field"
    t.string   "which_field_to_show"
  end

  create_table "jobs", :force => true do |t|
    t.string   "control_file",                                :null => false
    t.datetime "created_at",                                  :null => false
    t.datetime "completed_at"
    t.string   "status"
    t.integer  "batch_id",     :precision => 38, :scale => 0
  end

  add_index "jobs", ["batch_id"], :name => "index_jobs_on_batch_id"

  create_table "jointables", :force => true do |t|
    t.integer  "report_id",  :precision => 38, :scale => 0
    t.string   "table1"
    t.string   "table2"
    t.string   "whichjoin"
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
  end

  create_table "maintables", :force => true do |t|
    t.integer  "report_id",  :precision => 38, :scale => 0
    t.string   "table"
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
  end

  create_table "mem_reports", :force => true do |t|
    t.integer  "branch_id",  :precision => 38, :scale => 0
    t.integer  "plan_id",    :precision => 38, :scale => 0
    t.integer  "to_book",    :precision => 38, :scale => 0
    t.integer  "from_book",  :precision => 38, :scale => 0
    t.datetime "to_date"
    t.datetime "from_date"
    t.string   "day_limit"
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
  end

  create_table "ordertables", :force => true do |t|
    t.integer  "report_id",         :precision => 38, :scale => 0
    t.string   "table_attribute"
    t.string   "desc_asce"
    t.string   "expo_default_flag"
    t.datetime "created_at",                                       :null => false
    t.datetime "updated_at",                                       :null => false
  end

  create_table "reports", :force => true do |t|
    t.string   "description"
    t.integer  "invoke_times", :precision => 38, :scale => 0
    t.datetime "created_at",                                  :null => false
    t.datetime "updated_at",                                  :null => false
  end

  create_table "selecttables", :force => true do |t|
    t.integer  "report_id",       :precision => 38, :scale => 0
    t.string   "table_attribute"
    t.datetime "created_at",                                     :null => false
    t.datetime "updated_at",                                     :null => false
    t.string   "label"
  end

  create_table "temp2ibtrves", :force => true do |t|
    t.integer  "ibtr_id",          :precision => 38, :scale => 0
    t.string   "state"
    t.integer  "created_by",       :precision => 38, :scale => 0
    t.integer  "created_at_int",   :precision => 38, :scale => 0
    t.integer  "updated_at_int",   :precision => 38, :scale => 0
    t.string   "flag_destination"
    t.integer  "book_state",       :precision => 38, :scale => 0
    t.datetime "created_at_date"
    t.datetime "updated_at_date"
  end

  create_table "tempibtrves", :force => true do |t|
    t.integer  "ibtr_id",          :precision => 38, :scale => 0
    t.string   "state"
    t.integer  "created_by",       :precision => 38, :scale => 0
    t.integer  "created_at_int",   :precision => 38, :scale => 0
    t.integer  "updated_at_int",   :precision => 38, :scale => 0
    t.string   "flag_destination"
    t.integer  "book_id",          :precision => 38, :scale => 0
    t.datetime "created_at_date"
    t.datetime "updated_at_date"
  end

  create_table "wheretables", :force => true do |t|
    t.integer  "report_id",           :precision => 38, :scale => 0
    t.string   "table_attribute"
    t.string   "r_operator"
    t.string   "value"
    t.string   "expo_default_flag"
    t.datetime "created_at",                                         :null => false
    t.datetime "updated_at",                                         :null => false
    t.string   "which_field"
    t.string   "which_table"
    t.string   "which_field_to_show"
  end

end
