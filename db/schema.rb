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

ActiveRecord::Schema[8.1].define(version: 2026_08_06_154306) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"
  enable_extension "pg_trgm"

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

  create_table "activities", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "icon_key"
    t.integer "position"
    t.boolean "published"
    t.string "slug"
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_activities_on_slug", unique: true
  end

  create_table "activity_translations", force: :cascade do |t|
    t.bigint "activity_id", null: false
    t.datetime "created_at", null: false
    t.text "description"
    t.string "locale", null: false
    t.text "meta_description"
    t.string "name"
    t.string "seo_title"
    t.string "tagline"
    t.datetime "updated_at", null: false
    t.index ["activity_id", "locale"], name: "index_activity_translations_on_activity_id_and_locale", unique: true
    t.index ["locale"], name: "index_activity_translations_on_locale"
  end

  create_table "article_photo_translations", force: :cascade do |t|
    t.bigint "article_photo_id", null: false
    t.string "caption"
    t.datetime "created_at", null: false
    t.string "locale", null: false
    t.datetime "updated_at", null: false
    t.index ["article_photo_id", "locale"], name: "index_710f70e92686b769f2cbc779630c9f5dedcb64ee", unique: true
    t.index ["locale"], name: "index_article_photo_translations_on_locale"
  end

  create_table "article_photos", force: :cascade do |t|
    t.bigint "article_id", null: false
    t.datetime "created_at", null: false
    t.string "credit"
    t.integer "position"
    t.datetime "updated_at", null: false
    t.index ["article_id"], name: "index_article_photos_on_article_id"
  end

  create_table "article_translations", force: :cascade do |t|
    t.bigint "article_id", null: false
    t.datetime "created_at", null: false
    t.string "headline"
    t.string "locale", null: false
    t.text "meta_description"
    t.string "seo_title"
    t.string "subheadline"
    t.datetime "updated_at", null: false
    t.index ["article_id", "locale"], name: "index_article_translations_on_article_id_and_locale", unique: true
    t.index ["locale"], name: "index_article_translations_on_locale"
  end

  create_table "articles", force: :cascade do |t|
    t.bigint "activity_id"
    t.integer "article_type", null: false
    t.bigint "author_id", null: false
    t.datetime "created_at", null: false
    t.string "dateline_place"
    t.bigint "event_id"
    t.boolean "featured", default: false, null: false
    t.boolean "needs_english_translation", default: false, null: false
    t.datetime "published_at"
    t.bigint "published_by_id"
    t.string "slug", null: false
    t.integer "status", default: 0, null: false
    t.datetime "updated_at", null: false
    t.integer "view_count", default: 0, null: false
    t.index ["activity_id"], name: "index_articles_on_activity_id"
    t.index ["author_id"], name: "index_articles_on_author_id"
    t.index ["event_id"], name: "index_articles_on_event_id"
    t.index ["published_at"], name: "index_articles_on_published_at"
    t.index ["published_by_id"], name: "index_articles_on_published_by_id"
    t.index ["slug"], name: "index_articles_on_slug", unique: true
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

  create_table "event_photo_translations", force: :cascade do |t|
    t.string "caption"
    t.datetime "created_at", null: false
    t.bigint "event_photo_id", null: false
    t.string "locale", null: false
    t.datetime "updated_at", null: false
    t.index ["event_photo_id", "locale"], name: "index_event_photo_translations_on_event_photo_id_and_locale", unique: true
    t.index ["locale"], name: "index_event_photo_translations_on_locale"
  end

  create_table "event_photos", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "credit"
    t.bigint "event_id", null: false
    t.integer "position"
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_event_photos_on_event_id"
  end

  create_table "event_translations", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description"
    t.bigint "event_id", null: false
    t.string "locale", null: false
    t.string "title"
    t.datetime "updated_at", null: false
    t.string "venue_note"
    t.index ["event_id", "locale"], name: "index_event_translations_on_event_id_and_locale", unique: true
    t.index ["locale"], name: "index_event_translations_on_locale"
  end

  create_table "events", force: :cascade do |t|
    t.bigint "activity_id"
    t.datetime "created_at", null: false
    t.datetime "ends_at"
    t.boolean "published", default: false, null: false
    t.string "slug", null: false
    t.datetime "starts_at"
    t.datetime "updated_at", null: false
    t.text "venue_address"
    t.string "venue_name"
    t.string "youtube_id"
    t.index ["activity_id"], name: "index_events_on_activity_id"
    t.index ["slug"], name: "index_events_on_slug", unique: true
    t.index ["starts_at"], name: "index_events_on_starts_at"
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

  create_table "mentions", force: :cascade do |t|
    t.bigint "article_id", null: false
    t.datetime "created_at", null: false
    t.bigint "person_id", null: false
    t.datetime "updated_at", null: false
    t.index ["article_id", "person_id"], name: "index_mentions_on_article_id_and_person_id", unique: true
    t.index ["article_id"], name: "index_mentions_on_article_id"
    t.index ["person_id"], name: "index_mentions_on_person_id"
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
    t.string "youtube_url"
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
  add_foreign_key "activity_translations", "activities"
  add_foreign_key "article_photo_translations", "article_photos"
  add_foreign_key "article_photos", "articles"
  add_foreign_key "article_translations", "articles"
  add_foreign_key "articles", "activities"
  add_foreign_key "articles", "events"
  add_foreign_key "articles", "users", column: "author_id"
  add_foreign_key "committee_translations", "committees"
  add_foreign_key "event_photo_translations", "event_photos"
  add_foreign_key "event_photos", "events"
  add_foreign_key "event_translations", "events"
  add_foreign_key "events", "activities"
  add_foreign_key "membership_translations", "memberships"
  add_foreign_key "memberships", "committees"
  add_foreign_key "memberships", "people"
  add_foreign_key "mentions", "articles"
  add_foreign_key "mentions", "people"
  add_foreign_key "person_translations", "people"
  add_foreign_key "sessions", "users"
end
