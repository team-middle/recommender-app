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

ActiveRecord::Schema.define(version: 20131119183546) do

  create_table "ks_project_backers", force: true do |t|
    t.integer "ks_user_id"
    t.integer "ks_project_id"
  end

  add_index "ks_project_backers", ["ks_project_id"], name: "index_ks_project_backers_on_ks_project_id"
  add_index "ks_project_backers", ["ks_user_id"], name: "index_ks_project_backers_on_ks_user_id"

  create_table "ks_projects", force: true do |t|
    t.string  "url"
    t.integer "backer_count"
    t.string  "title"
    t.string  "creator_id"
    t.string  "parent_category"
    t.string  "category"
    t.integer "funding_goal"
    t.integer "pledged"
    t.string  "latitude"
    t.string  "longitude"
    t.integer "updates_count"
    t.integer "comments_count"
    t.boolean "scraped"
  end

  create_table "ks_users", force: true do |t|
    t.string  "url"
    t.boolean "scraped"
  end

end
