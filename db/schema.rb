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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170224105906) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree
  end

  create_table "quota", force: :cascade do |t|
    t.string   "name",       limit: 128,                null: false
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.string   "slug",       limit: 128,                null: false
    t.boolean  "approved",               default: true, null: false
    t.integer  "tenant_id"
    t.index ["approved"], name: "index_quota_on_approved", using: :btree
    t.index ["name"], name: "index_quota_on_name", unique: true, using: :btree
    t.index ["slug"], name: "index_quota_on_slug", unique: true, using: :btree
    t.index ["tenant_id"], name: "index_quota_on_tenant_id", using: :btree
  end

  create_table "tenants", force: :cascade do |t|
    t.string   "name",       limit: 64
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  create_table "user_tenants", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "tenant_id"
    t.integer  "permission_level"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.index ["permission_level"], name: "index_user_tenants_on_permission_level", using: :btree
    t.index ["user_id", "tenant_id"], name: "index_user_tenants_on_user_id_and_tenant_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "name",                   limit: 64, default: "",    null: false
    t.string   "email",                  limit: 92
    t.string   "encrypted_password",                default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                     default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.integer  "failed_attempts",                   default: 0,     null: false
    t.datetime "locked_at"
    t.datetime "created_at",                                        null: false
    t.datetime "updated_at",                                        null: false
    t.integer  "tenant_id"
    t.boolean  "guest",                             default: false, null: false
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["guest"], name: "index_users_on_guest", using: :btree
    t.index ["name"], name: "index_users_on_name", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
    t.index ["tenant_id"], name: "index_users_on_tenant_id", using: :btree
  end

end
