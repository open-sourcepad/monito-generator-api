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

ActiveRecord::Schema.define(version: 2018_10_14_183421) do

  create_table "auth_tokens", force: :cascade do |t|
    t.integer "user_id"
    t.datetime "expiry"
    t.string "auth_hash"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "circles", force: :cascade do |t|
    t.string "circle_name"
    t.string "budget"
    t.date "exchange_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.string "owner"
  end

  create_table "circles_users", id: false, force: :cascade do |t|
    t.integer "circle_id", null: false
    t.integer "user_id", null: false
    t.index ["circle_id"], name: "index_circles_users_on_circle_id"
    t.index ["user_id"], name: "index_circles_users_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "user_name"
    t.string "email"
    t.string "password_hash"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "circle_id"
  end

end
