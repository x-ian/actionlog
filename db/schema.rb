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

ActiveRecord::Schema.define(:version => 20090516213730) do

  create_table "accounts", :force => true do |t|
    t.string   "login",                     :limit => 40,                         :null => false
    t.string   "name",                      :limit => 100, :default => "",        :null => false
    t.string   "email",                     :limit => 100,                        :null => false
    t.string   "crypted_password",          :limit => 40,                         :null => false
    t.string   "salt",                      :limit => 40,                         :null => false
    t.datetime "created_at",                                                      :null => false
    t.datetime "updated_at",                                                      :null => false
    t.string   "remember_token",            :limit => 40,                         :null => false
    t.datetime "remember_token_expires_at",                                       :null => false
    t.string   "activation_code",           :limit => 40,                         :null => false
    t.datetime "activated_at",                                                    :null => false
    t.string   "state",                                    :default => "passive", :null => false
    t.datetime "deleted_at",                                                      :null => false
    t.string   "pw",                                                              :null => false
  end

  add_index "accounts", ["login"], :name => "index_accounts_on_login", :unique => true

  create_table "action_priorities", :force => true do |t|
    t.string   "level",                      :null => false
    t.string   "description", :limit => nil, :null => false
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
  end

  create_table "action_statuses", :force => true do |t|
    t.string   "name",       :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "action_types", :force => true do |t|
    t.string   "name",       :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "action_verbs", :force => true do |t|
    t.string   "verb",       :null => false
    t.boolean  "disliked",   :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "aktions", :force => true do |t|
    t.date     "log_date",                                     :null => false
    t.date     "assignment_date",                              :null => false
    t.string   "action_required",                              :null => false
    t.date     "review_date",                                  :null => false
    t.date     "target_date",                                  :null => false
    t.date     "new_target_date",                              :null => false
    t.boolean  "new_target_date_changed",                      :null => false
    t.string   "closeout_comment",              :limit => nil, :null => false
    t.date     "actual_completion_date",                       :null => false
    t.integer  "event_id",                                     :null => false
    t.integer  "requested_by_id",                              :null => false
    t.integer  "primary_responsible_id",                       :null => false
    t.integer  "secondary_responsible_id",                     :null => false
    t.integer  "action_priority_id",                           :null => false
    t.integer  "action_status_id",                             :null => false
    t.datetime "created_at",                                   :null => false
    t.datetime "updated_at",                                   :null => false
    t.date     "internal_due_date_for_sorting",                :null => false
    t.integer  "action_type_id",                               :null => false
    t.integer  "closed_by_id",                                 :null => false
  end

  create_table "customized_field_types", :force => true do |t|
    t.string   "name",       :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "customized_schemas", :force => true do |t|
    t.integer  "organizational_unit_id",                  :null => false
    t.integer  "customized_field_type_id",                :null => false
    t.string   "name",                                    :null => false
    t.string   "size",                                    :null => false
    t.string   "description",              :limit => nil, :null => false
    t.datetime "created_at",                              :null => false
    t.datetime "updated_at",                              :null => false
  end

  create_table "customized_values", :force => true do |t|
    t.integer  "customized_schema_id",                :null => false
    t.integer  "aktion_id",                           :null => false
    t.integer  "event_id",                            :null => false
    t.string   "value",                :limit => nil, :null => false
    t.datetime "created_at",                          :null => false
    t.datetime "updated_at",                          :null => false
  end

  create_table "event_areas", :force => true do |t|
    t.string   "name",                       :null => false
    t.integer  "meeting_id",                 :null => false
    t.string   "description", :limit => nil, :null => false
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
  end

  create_table "event_types", :force => true do |t|
    t.string   "name",       :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

# Could not dump table "events" because of following StandardError
#   Unknown type '' for column 'id'

  create_table "meetings", :force => true do |t|
    t.string   "name",                                   :null => false
    t.integer  "organizational_unit_id",                 :null => false
    t.string   "description",             :limit => nil, :null => false
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.integer  "responsible_user_id",                    :null => false
    t.string   "private_events_password",                :null => false
  end

  create_table "meetings_users", :id => false, :force => true do |t|
    t.integer "meeting_id", :null => false
    t.integer "user_id",    :null => false
  end

  create_table "minutes", :force => true do |t|
    t.string   "name",          :limit => nil, :null => false
    t.integer  "event_area_id",                :null => false
    t.integer  "user_id",                      :null => false
    t.date     "meeting_date",                 :null => false
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
  end

  create_table "organizational_units", :force => true do |t|
    t.string   "name",                                              :null => false
    t.integer  "parent_id",                                         :null => false
    t.string   "description",         :limit => nil,                :null => false
    t.datetime "created_at",                                        :null => false
    t.datetime "updated_at",                                        :null => false
    t.integer  "lft",                                               :null => false
    t.integer  "rgt",                                               :null => false
    t.integer  "lock_version",                       :default => 0, :null => false
    t.integer  "responsible_user_id",                               :null => false
  end

  create_table "organizational_units_users", :id => false, :force => true do |t|
    t.integer "organizational_unit_id", :null => false
    t.integer "user_id",                :null => false
  end

  create_table "priorities", :force => true do |t|
    t.string   "level",                      :null => false
    t.string   "description", :limit => nil, :null => false
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
  end

  create_table "priorities_priority_ranges", :id => false, :force => true do |t|
    t.integer "priority_id",       :null => false
    t.integer "priority_range_id", :null => false
  end

  create_table "priority_axes", :force => true do |t|
    t.string   "name",                       :null => false
    t.string   "description", :limit => nil, :null => false
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
  end

  create_table "priority_ranges", :force => true do |t|
    t.string   "value",                           :null => false
    t.string   "description",      :limit => nil, :null => false
    t.integer  "priority_axis_id",                :null => false
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
  end

  create_table "roles", :force => true do |t|
    t.string   "name",       :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "name",                           :null => false
    t.string   "email",                          :null => false
    t.boolean  "inactive",    :default => false, :null => false
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
    t.integer  "account_id",                     :null => false
    t.string   "pw",                             :null => false
    t.string   "login",                          :null => false
    t.integer  "role_id",     :default => 1,     :null => false
    t.integer  "meeting_id",                     :null => false
    t.boolean  "public_user", :default => false, :null => false
  end

end
