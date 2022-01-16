# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2022_01_16_032122) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "citext"
  enable_extension "plpgsql"

  create_table "feeds", force: :cascade do |t|
    t.citext "token", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "name"
    t.datetime "fetched_at", precision: 6
    t.index ["fetched_at"], name: "index_feeds_on_fetched_at"
    t.index ["token"], name: "index_feeds_on_token", unique: true
  end

  create_table "posts", force: :cascade do |t|
    t.bigint "feed_id"
    t.jsonb "payload"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.citext "token", null: false
    t.index ["feed_id", "updated_at"], name: "index_posts_on_feed_id_and_updated_at", order: { updated_at: :desc }
    t.index ["feed_id"], name: "index_posts_on_feed_id"
    t.index ["token"], name: "index_posts_on_token", unique: true
  end

end
