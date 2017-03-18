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

ActiveRecord::Schema.define(version: 20170318015744) do

  create_table "comments", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "youtube_video_id"
    t.text     "text"
    t.integer  "reply",            default: 0
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  create_table "impressions", force: :cascade do |t|
    t.string   "impressionable_type"
    t.integer  "impressionable_id"
    t.integer  "user_id"
    t.string   "controller_name"
    t.string   "action_name"
    t.string   "view_name"
    t.string   "request_hash"
    t.string   "ip_address"
    t.string   "session_hash"
    t.text     "message"
    t.text     "referrer"
    t.string   "params"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["controller_name", "action_name", "ip_address"], name: "controlleraction_ip_index"
    t.index ["controller_name", "action_name", "request_hash"], name: "controlleraction_request_index"
    t.index ["controller_name", "action_name", "session_hash"], name: "controlleraction_session_index"
    t.index ["impressionable_type", "impressionable_id", "ip_address"], name: "poly_ip_index"
    t.index ["impressionable_type", "impressionable_id", "params"], name: "poly_params_request_index"
    t.index ["impressionable_type", "impressionable_id", "request_hash"], name: "poly_request_index"
    t.index ["impressionable_type", "impressionable_id", "session_hash"], name: "poly_session_index"
    t.index ["impressionable_type", "message", "impressionable_id"], name: "impressionable_type_message_index"
    t.index ["user_id"], name: "index_impressions_on_user_id"
  end

  create_table "likes", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "youtube_video_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  create_table "site_configurations", force: :cascade do |t|
    t.string   "item"
    t.string   "summary"
    t.text     "contents"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "top_tag_lists", force: :cascade do |t|
    t.string   "genre",      default: "注目キーワード"
    t.string   "tag_name"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.string   "hurigana"
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "",   null: false
    t.string   "encrypted_password",     default: "",   null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,    null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.string   "username"
    t.integer  "user_level",             default: 1
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.boolean  "acceptance",             default: true, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "view_histories", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "youtube_video_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.index ["user_id"], name: "index_view_histories_on_user_id"
  end

  create_table "youtube_video_tags", force: :cascade do |t|
    t.integer  "youtube_video_id"
    t.string   "name"
    t.boolean  "master_tag",       default: false
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
  end

  create_table "youtube_videos", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "title"
    t.text     "url"
    t.text     "text"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.string   "catchphrase"
    t.string   "category"
    t.integer  "pickup_level"
    t.text     "poster_comment"
    t.integer  "pv_count",       default: 0
    t.integer  "likes_count"
    t.string   "video_time"
  end

end
