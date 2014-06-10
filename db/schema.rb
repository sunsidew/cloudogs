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

ActiveRecord::Schema.define(version: 20140610105244) do

  create_table "dialogs", force: true do |t|
    t.integer  "docs_id"
    t.string   "filename"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "docs", force: true do |t|
    t.string   "title"
    t.string   "filename"
    t.integer  "now_history_id"
    t.integer  "owner_user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "docs_histories", force: true do |t|
    t.integer  "docs_id"
    t.string   "description"
    t.integer  "prev_histroy_id"
    t.integer  "next_histroy_id"
    t.integer  "by_user_id"
    t.string   "by_user_email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "login_email"
    t.string   "login_crypt_pw"
    t.string   "username"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
