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

ActiveRecord::Schema.define(version: 2018_05_29_132135) do

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
    t.integer "slack_messages_count", default: 0
    t.integer "slack_reactions_count", default: 0
  end

  add_foreign_key "slack_messages", "slack_channels"
  add_foreign_key "slack_messages", "users"
  add_foreign_key "slack_reactions", "slack_channels"
  add_foreign_key "slack_reactions", "users"

  create_view "channel_usages",  sql_definition: <<-SQL
      SELECT u.id AS user_id,
      messages.messages_given,
      messages.channel,
      messages.channel_slack_identifier,
      messages.day
     FROM (users u
       JOIN ( SELECT sm.user_id AS id,
              sc.name AS channel,
              sc.slack_identifier AS channel_slack_identifier,
              count(sm.user_id) AS messages_given,
              date(sm.created_at) AS day
             FROM (slack_messages sm
               JOIN slack_channels sc ON ((sc.id = sm.slack_channel_id)))
            GROUP BY sm.user_id, sc.name, sc.slack_identifier, (date(sm.created_at))) messages USING (id));
  SQL

  create_view "reaction_usages",  sql_definition: <<-SQL
      SELECT u.id AS user_id,
      reactions.reactions_given,
      reactions.emoji,
      reactions.day
     FROM (users u
       JOIN ( SELECT sr.user_id AS id,
              sr.emoji,
              count(sr.user_id) AS reactions_given,
              date(sr.created_at) AS day
             FROM slack_reactions sr
            GROUP BY sr.user_id, sr.emoji, (date(sr.created_at))) reactions USING (id));
  SQL

end
