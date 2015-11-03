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

ActiveRecord::Schema.define(version: 20151101191217) do

  create_table "train_stops", force: :cascade do |t|
    t.integer  "STOP_ID"
    t.string   "DIRECTION_ID"
    t.string   "STOP_NAME"
    t.string   "STATION_NAME"
    t.string   "STATION_DESCRIPTIVE_NAME"
    t.string   "MAP_ID"
    t.boolean  "ADA"
    t.boolean  "RED"
    t.boolean  "BLUE"
    t.boolean  "G"
    t.boolean  "BRN"
    t.boolean  "P"
    t.boolean  "Pexp"
    t.boolean  "Y"
    t.boolean  "Pnk"
    t.boolean  "O"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.string   "Location"
  end

  create_table "transportations", force: :cascade do |t|
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.string   "route_id"
    t.string   "route_short_name"
    t.string   "route_long_name"
    t.integer  "route_type"
    t.string   "route_url"
    t.string   "route_color"
    t.string   "route_text_color"
  end

  add_index "transportations", ["route_id"], name: "index_transportations_on_route_id"

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.string   "password_digest"
    t.string   "rember_digest"
    t.string   "provider"
    t.string   "uid"
    t.string   "oauth_token"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.datetime "oauth_expires_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true

end
