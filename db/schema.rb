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

ActiveRecord::Schema[8.1].define(version: 2026_08_05_141010) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"
  enable_extension "pg_trgm"

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
end
