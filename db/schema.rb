# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20090222183506) do

  create_table "accounts", :force => true do |t|
    t.string   "login",                     :limit => 40
    t.string   "name",                      :limit => 100, :default => ""
    t.string   "email",                     :limit => 100
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token",            :limit => 40
    t.datetime "remember_token_expires_at"
  end

  add_index "accounts", ["login"], :name => "index_accounts_on_login", :unique => true

  create_table "action_priorities", :force => true do |t|
    t.string   "level"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "action_statuses", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "action_types", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "action_verbs", :force => true do |t|
    t.string   "verb"
    t.boolean  "disliked"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "aktions", :force => true do |t|
    t.date     "log_date"
    t.date     "assignment_date"
    t.string   "action_required"
    t.date     "review_date"
    t.date     "target_date"
    t.date     "new_target_date"
    t.boolean  "new_target_date_changed"
    t.text     "closeout_comment"
    t.date     "actual_completion_date"
    t.integer  "event_id"
    t.integer  "requested_by_id"
    t.integer  "primary_responsible_id"
    t.integer  "secondary_responsible_id"
    t.integer  "action_priority_id"
    t.integer  "action_status_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "internal_due_date_for_sorting"
    t.integer  "action_type_id"
    t.integer  "closed_by_id"
  end

  create_table "event_areas", :force => true do |t|
    t.string   "name"
    t.integer  "meeting_id"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "event_types", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "events", :force => true do |t|
    t.string   "name"
    t.date     "log_date"
    t.integer  "event_area_id"
    t.integer  "escalated_event_area_id"
    t.integer  "event_type_id"
    t.integer  "user_id"
    t.integer  "priority_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "meeting_date"
  end

  create_table "meetings", :force => true do |t|
    t.string   "name"
    t.integer  "organizational_unit_id"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "meetings_users", :id => false, :force => true do |t|
    t.integer "meeting_id"
    t.integer "user_id"
  end

  create_table "minutes", :force => true do |t|
    t.text     "name"
    t.integer  "event_area_id"
    t.integer  "user_id"
    t.date     "meeting_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "organizational_units", :force => true do |t|
    t.string   "name"
    t.integer  "parent_id"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "lft",                                :null => false
    t.integer  "rgt",                                :null => false
    t.integer  "lock_version",        :default => 0
    t.integer  "responsible_user_id"
  end

  create_table "organizational_units_users", :id => false, :force => true do |t|
    t.integer "organizational_unit_id"
    t.integer "user_id"
  end

  create_table "priorities", :force => true do |t|
    t.string   "level"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "priorities_priority_ranges", :id => false, :force => true do |t|
    t.integer "priority_id"
    t.integer "priority_range_id"
  end

  create_table "priority_axes", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "priority_ranges", :force => true do |t|
    t.string   "value"
    t.text     "description"
    t.integer  "priority_axis_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.boolean  "inactive"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "account_id"
    t.string   "pw"
    t.string   "login"
    t.integer  "role_id"
    t.integer  "meeting_id"
  end

end
