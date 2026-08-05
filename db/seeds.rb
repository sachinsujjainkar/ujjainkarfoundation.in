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
  # Confirmed against docs/content/foundation/impact-statistics.md and
  # docs/content/events.md's numbers table (Sachin, 2026-08-05). stat_1 and
  # stat_2 are direct source matches. stat_3 was a judgment call between two
  # source-offered options (years of continuous service vs. free eye
  # screenings) -- picked "years of service" because it's org-wide rather
  # than specific to one कार्यक्षेत्र (the other two stats are both
  # recognition/award counts, so this adds variety) and because it echoes
  # the "25 years" figure already in home.hero_supporting rather than
  # introducing a fourth, unrelated claim. Easy to swap -- it's a column,
  # not code.
  stat_1_label_mr: "गुणवंत विद्यार्थी सन्मानित",
  stat_1_label_en: "Students Honoured",
  stat_1_value: "१,०००+",
  stat_2_label_mr: "साहित्यिक तापी-पूर्णा पुरस्काराने सन्मानित",
  stat_2_label_en: "Writers Awarded (Tapi-Purna)",
  stat_2_value: "८००+",
  stat_3_label_mr: "वर्षांचा अखंड सामाजिक कार्याचा वारसा",
  stat_3_label_en: "Years of Continuous Service",
  stat_3_value: "२५+"
  # Everything else (phones, email, social, map, donation details, 12A/80G)
  # is still unconfirmed -- left as the column default (nil/false).
)
