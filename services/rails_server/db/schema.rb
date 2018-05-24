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

ActiveRecord::Schema.define(version: 2018_05_20_100217) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "slack_channels", force: :cascade do |t|
    t.string "slack_identifier", null: false
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slack_identifier"], name: "index_slack_channels_on_slack_identifier"
  end

  create_table "slack_messages", force: :cascade do |t|
    t.bigint "slack_channel_id"
    t.bigint "user_id"
    t.string "ts"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slack_channel_id"], name: "index_slack_messages_on_slack_channel_id"
    t.index ["user_id"], name: "index_slack_messages_on_user_id"
  end

  create_table "slack_reactions", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "slack_channel_id"
    t.string "emoji", null: false
    t.string "target", null: false
    t.string "slack_identifier", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["emoji"], name: "index_slack_reactions_on_emoji"
    t.index ["slack_channel_id"], name: "index_slack_reactions_on_slack_channel_id"
    t.index ["slack_identifier"], name: "index_slack_reactions_on_slack_identifier"
    t.index ["target"], name: "index_slack_reactions_on_target"
    t.index ["user_id"], name: "index_slack_reactions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "slack_identifier"
    t.string "slack_handle"
    t.string "real_name"
    t.string "profile_image"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "slack_messages", "slack_channels"
  add_foreign_key "slack_messages", "users"
  add_foreign_key "slack_reactions", "slack_channels"
  add_foreign_key "slack_reactions", "users"
end
