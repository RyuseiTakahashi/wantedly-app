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

ActiveRecord::Schema.define(version: 20180422163203) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "adminpack"

  create_table "skill_masters", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "skill_recommends", force: :cascade do |t|
    t.integer "owner_user_id"
    t.bigint "user_id"
    t.bigint "skill_master_id"
    t.integer "recommend_flg"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["skill_master_id"], name: "index_skill_recommends_on_skill_master_id"
    t.index ["user_id"], name: "index_skill_recommends_on_user_id"
  end

  create_table "skills", force: :cascade do |t|
    t.bigint "skill_master_id"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["skill_master_id"], name: "index_skills_on_skill_master_id"
    t.index ["user_id"], name: "index_skills_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
