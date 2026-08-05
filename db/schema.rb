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

ActiveRecord::Schema[8.1].define(version: 2026_08_05_191404) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"
  enable_extension "pg_trgm"

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

  create_table "committee_translations", force: :cascade do |t|
    t.bigint "committee_id", null: false
    t.datetime "created_at", null: false
    t.string "locale", null: false
    t.string "name"
    t.datetime "updated_at", null: false
    t.index ["committee_id", "locale"], name: "index_committee_translations_on_committee_id_and_locale", unique: true
    t.index ["locale"], name: "index_committee_translations_on_locale"
  end

  create_table "committees", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "position", default: 0, null: false
    t.datetime "updated_at", null: false
  end

  create_table "contact_messages", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email", null: false
    t.text "message", null: false
    t.string "name", null: false
    t.boolean "read", default: false, null: false
    t.string "subject"
    t.datetime "updated_at", null: false
  end

  create_table "membership_translations", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "locale", null: false
    t.bigint "membership_id", null: false
    t.string "role_title"
    t.datetime "updated_at", null: false
    t.index ["locale"], name: "index_membership_translations_on_locale"
    t.index ["membership_id", "locale"], name: "index_membership_translations_on_membership_id_and_locale", unique: true
  end

  create_table "memberships", force: :cascade do |t|
    t.bigint "committee_id", null: false
    t.datetime "created_at", null: false
    t.bigint "person_id", null: false
    t.integer "position_order", default: 0, null: false
    t.datetime "updated_at", null: false
    t.index ["committee_id"], name: "index_memberships_on_committee_id"
    t.index ["person_id"], name: "index_memberships_on_person_id"
  end

  create_table "people", force: :cascade do |t|
    t.string "city"
    t.boolean "committee_member", default: false, null: false
    t.datetime "created_at", null: false
    t.string "email"
    t.string "phone"
    t.integer "position_order", default: 0, null: false
    t.string "slug", null: false
    t.date "term_end"
    t.date "term_start"
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_people_on_slug", unique: true
  end

  create_table "person_translations", force: :cascade do |t|
    t.text "bio"
    t.datetime "created_at", null: false
    t.string "honorific"
    t.string "locale", null: false
    t.string "name"
    t.bigint "person_id", null: false
    t.datetime "updated_at", null: false
    t.index ["locale"], name: "index_person_translations_on_locale"
    t.index ["person_id", "locale"], name: "index_person_translations_on_person_id_and_locale", unique: true
  end

  create_table "sessions", force: :cascade do |t|
    t.string "ip_address"
    t.string "user_agent"
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "site_settings", force: :cascade do |t|
    t.string "address_line1"
    t.string "address_line2"
    t.string "city"
    t.datetime "created_at", null: false
    t.string "district"
    t.text "donation_bank_details"
    t.string "donation_upi_id"
    t.string "email_public"
    t.string "facebook_url"
    t.boolean "has_12a", default: false, null: false
    t.boolean "has_80g", default: false, null: false
    t.string "instagram_url"
    t.string "iso_certification"
    t.string "map_embed_url"
    t.string "phone_primary"
    t.string "phone_secondary"
    t.string "pincode"
    t.date "registration_date"
    t.string "registration_number"
    t.string "registration_type"
    t.string "stat_1_label_en"
    t.string "stat_1_label_mr"
    t.string "stat_1_value"
    t.string "stat_2_label_en"
    t.string "stat_2_label_mr"
    t.string "stat_2_value"
    t.string "stat_3_label_en"
    t.string "stat_3_label_mr"
    t.string "stat_3_value"
    t.string "state"
    t.string "twitter_url"
    t.datetime "updated_at", null: false
    t.string "youtube_url"
  end

  create_table "users", force: :cascade do |t|
    t.boolean "active", default: true, null: false
    t.datetime "created_at", null: false
    t.string "email_address", null: false
    t.datetime "last_seen_at"
    t.string "name", null: false
    t.string "password_digest", null: false
    t.integer "role", default: 2, null: false
    t.datetime "updated_at", null: false
    t.index ["email_address"], name: "index_users_on_email_address", unique: true
  end

  create_table "volunteers", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email"
    t.string "interest_area"
    t.text "message"
    t.string "name", null: false
    t.string "phone", null: false
    t.string "status", default: "new", null: false
    t.string "taluka"
    t.datetime "updated_at", null: false
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "committee_translations", "committees"
  add_foreign_key "membership_translations", "memberships"
  add_foreign_key "memberships", "committees"
  add_foreign_key "memberships", "people"
  add_foreign_key "person_translations", "people"
  add_foreign_key "sessions", "users"
end
