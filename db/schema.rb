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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20140601025955) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "companies", force: true do |t|
    t.string   "name"
    t.string   "crunchbase_id"
    t.boolean  "exited",              default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "total_money_raised"
    t.integer  "number_of_employees"
    t.integer  "founded_year"
    t.integer  "founded_month"
  end

  create_table "investors", force: true do |t|
    t.string   "name"
    t.integer  "company_id"
    t.string   "crunchbase_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_companies", force: true do |t|
    t.integer  "user_id"
    t.integer  "company_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree

end
