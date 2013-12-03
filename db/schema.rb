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

ActiveRecord::Schema.define(version: 20131203141012) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "centers", force: true do |t|
    t.integer "art_score",         default: 0
    t.integer "comics_score",      default: 0
    t.integer "dance_score",       default: 0
    t.integer "design_score",      default: 0
    t.integer "fashion_score",     default: 0
    t.integer "film_score",        default: 0
    t.integer "food_score",        default: 0
    t.integer "games_score",       default: 0
    t.integer "music_score",       default: 0
    t.integer "photography_score", default: 0
    t.integer "publishing_score",  default: 0
    t.integer "technology_score",  default: 0
    t.integer "theater_score",     default: 0
  end

  create_table "ks_project_backers", force: true do |t|
    t.integer "ks_user_id"
    t.integer "ks_project_id"
  end

  add_index "ks_project_backers", ["ks_project_id"], name: "index_ks_project_backers_on_ks_project_id", using: :btree
  add_index "ks_project_backers", ["ks_user_id"], name: "index_ks_project_backers_on_ks_user_id", using: :btree

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
    t.text    "description"
    t.string  "end_date"
    t.string  "image_url"
    t.boolean "active"
    t.string  "video_url"
  end

  create_table "ks_users", force: true do |t|
    t.string  "url"
    t.boolean "scraped"
    t.integer "tech_score",        default: 0
    t.integer "art_score",         default: 0
    t.integer "comics_score",      default: 0
    t.integer "dance_score",       default: 0
    t.integer "design_score",      default: 0
    t.integer "fashion_score",     default: 0
    t.integer "film_score",        default: 0
    t.integer "food_score",        default: 0
    t.integer "games_score",       default: 0
    t.integer "music_score",       default: 0
    t.integer "photography_score", default: 0
    t.integer "publishing_score",  default: 0
    t.integer "technology_score",  default: 0
    t.integer "theater_score",     default: 0
    t.integer "center_id"
    t.string  "image_url"
    t.string  "name"
    t.string  "joined"
    t.text    "description"
    t.string  "location"
    t.text    "bio"
  end

  create_table "recommendations", force: true do |t|
    t.integer  "user_id"
    t.integer  "ks_project_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "useful"
  end

  add_index "recommendations", ["ks_project_id"], name: "index_recommendations_on_ks_project_id", using: :btree
  add_index "recommendations", ["user_id"], name: "index_recommendations_on_user_id", using: :btree

  create_table "user_follows", force: true do |t|
    t.integer  "user_id"
    t.integer  "ks_user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "username"
    t.integer  "art_score"
    t.integer  "comics_score"
    t.integer  "dance_score"
    t.integer  "design_score"
    t.integer  "fashion_score"
    t.integer  "film_score"
    t.integer  "food_score"
    t.integer  "games_score"
    t.integer  "music_score"
    t.integer  "photography_score"
    t.integer  "publishing_score"
    t.integer  "technology_score"
    t.integer  "theater_score"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "center_id"
  end

end
