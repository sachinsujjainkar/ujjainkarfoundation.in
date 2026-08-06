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

# The six confirmed कार्यक्षेत्रे -- slugs and order locked in
# prompts/phase-08-activities.md. Content transcribed from
# docs/content/programmes/*.md (Sachin, 2026-08-05). Real, not placeholder,
# so published: true from the start -- this is exactly the content those
# files were collected for.
ACTIVITIES = [
  {
    slug: "sahitya-sammelan", icon_key: "book",
    name_mr: "साहित्य संमेलन", name_en: "Literary Conference",
    tagline_mr: "राज्यस्तरीय व अखिल भारतीय मराठी साहित्य संमेलनांचे नियमित आयोजन.",
    tagline_en: "Regular state-level and All-India Marathi literary conferences.",
    description_mr: "राज्यस्तरीय व अखिल भारतीय मराठी साहित्य संमेलनांचे नियमित आयोजन.",
    description_en: "Regular state-level and All-India Marathi literary conferences."
  },
  {
    slug: "puraskar", icon_key: "award",
    name_mr: "पुरस्कार", name_en: "Award",
    tagline_mr: "तापी-पूर्णा राज्यस्तरीय पुरस्काराने साहित्यिक, शिक्षक व समाजसेवकांचा सन्मान.",
    tagline_en: "Honouring writers, teachers, and social workers through the Tapi-Purna state award.",
    description_mr: "तापी-पूर्णा राज्यस्तरीय पुरस्काराने साहित्यिक, शिक्षक व समाजसेवकांचा सन्मान.",
    description_en: "Honouring writers, teachers, and social workers through the Tapi-Purna state award."
  },
  {
    slug: "vidyarthi-satkar", icon_key: "graduation_cap",
    name_mr: "विद्यार्थी सत्कार", name_en: "Student Felicitation",
    tagline_mr: "गुणवंत विद्यार्थ्यांचा तालुकास्तरीय गौरव सोहळा, दरवर्षी.",
    tagline_en: "Annual taluka-level recognition of meritorious students.",
    description_mr: "गुणवंत विद्यार्थ्यांचा तालुकास्तरीय गौरव सोहळा, दरवर्षी.",
    description_en: "Annual taluka-level recognition of meritorious students."
  },
  {
    slug: "vyakhyanmala", icon_key: "podium",
    name_mr: "व्याख्यानमाला", name_en: "Lecture Series",
    tagline_mr: "नामवंत वक्त्यांची व्याख्याने — प्रत्यक्ष व ऑनलाइन दोन्ही स्वरूपात.",
    tagline_en: "Lectures by noted speakers, held both in person and online.",
    description_mr: "नामवंत वक्त्यांची व्याख्याने — प्रत्यक्ष व ऑनलाइन दोन्ही स्वरूपात.",
    description_en: "Lectures by noted speakers, held both in person and online."
  },
  {
    slug: "prakashan", icon_key: "document",
    name_mr: "प्रकाशन", name_en: "Publication",
    tagline_mr: "संमेलन विशेषांक व साहित्यिक पुस्तकांचे प्रकाशन.",
    tagline_en: "Publishing the annual संमेलन विशेषांक and literary books.",
    description_mr: "संमेलन विशेषांक व साहित्यिक पुस्तकांचे प्रकाशन.",
    description_en: "Publishing the annual संमेलन विशेषांक and literary books."
  },
  {
    # "aarogya-samajik" -- corrected 2026-08-06 (implementation briefing):
    # supersedes "arogya-va-samajik-upakram", which was the locked value
    # in an earlier version of prompts/phase-08-activities.md. That file
    # and docs/content/programmes/ have been updated to match.
    slug: "aarogya-samajik", icon_key: "heart",
    name_mr: "आरोग्य व सामाजिक उपक्रम", name_en: "Health & Social Initiatives",
    tagline_mr: "मोफत नेत्र तपासणी, रक्तदान व सामुदायिक आरोग्य शिबिरे.",
    tagline_en: "Free eye camps, blood donation, and community health drives.",
    description_mr: "मोफत नेत्र तपासणी, रक्तदान व सामुदायिक आरोग्य शिबिरे.",
    description_en: "Free eye camps, blood donation, and community health drives."
  }
].freeze

ACTIVITIES.each_with_index do |attrs, index|
  activity = Activity.find_or_initialize_by(slug: attrs.fetch(:slug))
  activity.update!(attrs.merge(position: index + 1, published: true))
end
