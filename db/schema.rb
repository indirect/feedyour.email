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

ActiveRecord::Schema[7.1].define(version: 2024_01_06_023950) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "citext"
  enable_extension "plpgsql"

  create_table "action_mailbox_inbound_emails", force: :cascade do |t|
    t.integer "status", default: 0, null: false
    t.string "message_id", null: false
    t.string "message_checksum", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["message_id", "message_checksum"], name: "index_action_mailbox_inbound_emails_uniqueness", unique: true
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "feeds", force: :cascade do |t|
    t.citext "token", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.datetime "fetched_at"
    t.index ["fetched_at"], name: "index_feeds_on_fetched_at"
    t.index ["token"], name: "index_feeds_on_token", unique: true
  end

  create_table "icons", force: :cascade do |t|
    t.bigint "feed_id", null: false
    t.string "tag_name"
    t.jsonb "tag_attrs"
    t.string "url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["feed_id"], name: "index_icons_on_feed_id"
  end

  create_table "posts", force: :cascade do |t|
    t.bigint "feed_id"
    t.jsonb "payload"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.citext "token", null: false
    t.string "from"
    t.string "subject"
    t.string "html_body"
    t.string "text_body"
    t.binary "compressed_html_body"
    t.binary "compressed_text_body"
    t.index ["feed_id", "updated_at"], name: "index_posts_on_feed_id_and_updated_at", order: { updated_at: :desc }
    t.index ["feed_id"], name: "index_posts_on_feed_id"
    t.index ["token"], name: "index_posts_on_token", unique: true
  end

  create_table "rmp_flamegraphs", force: :cascade do |t|
    t.integer "rmp_profiled_request_id", null: false
    t.binary "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["rmp_profiled_request_id"], name: "index_rmp_flamegraphs_on_rmp_profiled_request_id"
  end

  create_table "rmp_profiled_requests", force: :cascade do |t|
    t.string "user_id"
    t.bigint "start"
    t.bigint "finish"
    t.integer "duration"
    t.bigint "allocations"
    t.string "request_path"
    t.string "request_query_string"
    t.string "request_method"
    t.json "request_headers"
    t.text "request_body"
    t.integer "response_status"
    t.text "response_body"
    t.json "response_headers"
    t.string "response_media_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_at"], name: "index_rmp_profiled_requests_on_created_at"
  end

  create_table "rmp_traces", force: :cascade do |t|
    t.integer "rmp_profiled_request_id", null: false
    t.string "name"
    t.bigint "start"
    t.bigint "finish"
    t.integer "duration"
    t.bigint "allocations"
    t.json "payload"
    t.json "backtrace"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["rmp_profiled_request_id"], name: "index_rmp_traces_on_rmp_profiled_request_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "icons", "feeds"
  add_foreign_key "rmp_flamegraphs", "rmp_profiled_requests"
  add_foreign_key "rmp_traces", "rmp_profiled_requests"
end
