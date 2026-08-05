# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# SiteSetting is a singleton -- exactly one row, everything still-unconfirmed
# left nil/false rather than invented. See docs/00-project-brief.md, "Still
# unconfirmed", and "Nothing invented ships."
site_setting = SiteSetting.instance
site_setting.update!(
  registration_number: "एफ-११४७३ (जळगांव)",
  registration_type: "Public Trust",
  registration_date: Date.new(2010, 5, 12),
  iso_certification: "ISO 9001:2015",
  # ११५४२ / ०८-०१-२०१० on the logo seal is a separate (likely ISO) certificate
  # -- not this registration date. Do not conflate the two. See
  # prompts/phase-05-static-pages.md.
  address_line2: "ता. मुक्ताईनगर",
  city: "मुक्ताईनगर",
  district: "जळगाव",
  state: "महाराष्ट्र",
  pincode: "425306",
  # Labels only, not values -- prompts/phase-04-home-page.md names these
  # three as CANDIDATES pending the real record in docs/content/, which
  # doesn't exist in this repo yet. The label text ("what this stat
  # measures") isn't a factual claim the way a specific number is, so it's
  # safe to seed; stat_*_value stays nil until a real count is confirmed.
  # The homepage renders an em dash in place of a blank value rather than
  # inventing one -- see app/views/home/index.html.erb.
  stat_1_label_mr: "पुरस्कारप्राप्त मान्यवर",
  stat_1_label_en: "Awarded dignitaries",
  stat_2_label_mr: "गुणवंत विद्यार्थी सत्कार",
  stat_2_label_en: "Meritorious students honoured",
  stat_3_label_mr: "२०१० पासूनची साहित्य संमेलने",
  stat_3_label_en: "Literary conventions since 2010"
  # Everything else (phones, email, social, map, donation details, 12A/80G,
  # stat values) is still unconfirmed -- left as the column default (nil/false).
)
