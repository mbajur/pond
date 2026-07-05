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

ActiveRecord::Schema[8.1].define(version: 2026_06_26_130353) do
  create_table "action_text_rich_texts", force: :cascade do |t|
    t.text "body"
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.bigint "record_id", null: false
    t.string "record_type", null: false
    t.datetime "updated_at", null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.bigint "record_id", null: false
    t.string "record_type", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.string "content_type"
    t.datetime "created_at", null: false
    t.string "filename", null: false
    t.string "key", null: false
    t.text "metadata"
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "auth_codes", force: :cascade do |t|
    t.string "code", null: false
    t.datetime "created_at", null: false
    t.datetime "expires_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["code"], name: "index_auth_codes_on_code", unique: true
    t.index ["user_id"], name: "index_auth_codes_on_user_id"
  end

  create_table "collections", force: :cascade do |t|
    t.datetime "changed_at"
    t.datetime "created_at", null: false
    t.text "description"
    t.boolean "inbox", default: false, null: false
    t.string "name"
    t.integer "pins_count", default: 0
    t.boolean "private", default: false
    t.string "slug"
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.index ["slug"], name: "index_collections_on_slug", unique: true
    t.index ["user_id"], name: "index_collections_on_user_id"
  end

  create_table "data_migrations", primary_key: "version", id: :string, force: :cascade do |t|
  end

  create_table "follows", force: :cascade do |t|
    t.integer "actor_id", null: false
    t.datetime "created_at", null: false
    t.integer "target_id", null: false
    t.string "target_type", null: false
    t.datetime "updated_at", null: false
    t.index ["actor_id"], name: "index_follows_on_actor_id"
    t.index ["target_type", "target_id"], name: "index_follows_on_target"
  end

  create_table "pins", force: :cascade do |t|
    t.integer "collection_id"
    t.datetime "created_at", null: false
    t.json "options", default: {}
    t.integer "pinable_id", null: false
    t.string "pinable_type", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.index ["collection_id"], name: "index_pins_on_collection_id"
    t.index ["pinable_type", "pinable_id"], name: "index_pins_on_pinable"
    t.index ["user_id"], name: "index_pins_on_user_id"
  end

  create_table "posts", force: :cascade do |t|
    t.integer "collection_id"
    t.text "content"
    t.datetime "created_at", null: false
    t.text "description"
    t.string "title"
    t.string "type", default: "Post::Url", null: false
    t.datetime "updated_at", null: false
    t.string "url"
    t.integer "url_cache_id"
    t.integer "user_id"
    t.index ["collection_id"], name: "index_posts_on_collection_id"
    t.index ["url_cache_id"], name: "index_posts_on_url_cache_id"
    t.index ["user_id"], name: "index_posts_on_user_id"
  end

  create_table "sessions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "ip_address"
    t.datetime "updated_at", null: false
    t.string "user_agent"
    t.integer "user_id", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "url_caches", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description"
    t.datetime "refreshed_at"
    t.json "thumb_data"
    t.string "title"
    t.datetime "updated_at", null: false
    t.string "url", null: false
    t.index ["url"], name: "index_url_caches_on_url", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.boolean "admin", default: false, null: false
    t.datetime "created_at", null: false
    t.text "description"
    t.string "email_address", null: false
    t.string "name"
    t.datetime "premium_until"
    t.boolean "private", default: true
    t.datetime "updated_at", null: false
    t.string "username", null: false
    t.index ["email_address"], name: "index_users_on_email_address", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "auth_codes", "users"
  add_foreign_key "collections", "users"
  add_foreign_key "follows", "users", column: "actor_id"
  add_foreign_key "pins", "collections"
  add_foreign_key "pins", "users"
  add_foreign_key "posts", "collections"
  add_foreign_key "posts", "url_caches", column: "url_cache_id"
  add_foreign_key "posts", "users"
  add_foreign_key "sessions", "users"
end
