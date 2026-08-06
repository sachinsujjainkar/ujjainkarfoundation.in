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

# Real launch content, not placeholders -- the same three stories
# HomeController's NEWS_ITEMS used as a Phase 04 placeholder (see that
# file's comment), now real published Article records so the newsroom
# doesn't launch empty. Facts from docs/content/events.md (Sachin,
# 2026-08-05). Author is whichever admin account exists -- there's no
# other real staff account yet; Phase 07's admin panel is how a real one
# gets created going forward, this is just seed data to launch with.
#
# Driven through the model's own real workflow (create draft -> submit!
# -> publish via update!) instead of forcing status/slug columns directly
# -- exercises the exact same code path Article's own tests cover, rather
# than a separate, untested shortcut that could quietly drift from what
# the model actually enforces. Idempotency check is by headline_mr
# (joined through the translations table) since slug isn't known before
# the row exists to generate it from.
seed_author = User.find_by(role: :admin) || User.first
if seed_author
  Current.session = seed_author.sessions.create!

  [
    {
      article_type: :initiative, dateline_place: "आळंदी", published_at: Date.new(2025, 1, 4),
      headline_mr: "आळंदीत ७५० फूट लांबीची विश्वविक्रमी राखी संत ज्ञानेश्वर माऊलींना अर्पण",
      body_mr: "<div>आदिशक्ती संत मुक्ताई कडून संतश्रेष्ठ श्री ज्ञानेश्वर माऊलींना अर्पण करण्यात आलेल्या ७५० फूट लांब व ७५ किलो वजनाच्या राखीची हेरिटेज बुक ऑफ वर्ल्ड रेकॉर्ड्समध्ये नोंद झाली. संकल्पना प्राचार्य डॉ. सुरेंद्र हेरकळ (उज्जैनकर फाउंडेशन पुणे जिल्हा अध्यक्ष, संमेलन स्वागताध्यक्ष) यांची.</div>",
      headline_en: "750-foot record-setting rakhi offered to Sant Dnyaneshwar Mauli in Alandi",
      body_en: "<div>A 750-foot, 75-kilogram rakhi, offered on behalf of Adishakti Sant Muktai to Sant Dnyaneshwar Mauli, was recorded in the Heritage Book of World Records. The initiative was conceived by Principal Dr. Surendra Herkal (Ujjainkar Foundation Pune district president, conference reception chair).</div>",
      featured: true, person_name_mr: "डॉ. सुरेंद्र हेरकळ"
    },
    {
      article_type: :award, dateline_place: "मुक्ताईनगर", published_at: Date.new(2020, 6, 15),
      headline_mr: "कोरोना काळात सेवा देणाऱ्या १,४२८ समाजसेवकांचा ऑनलाइन सन्मान",
      body_mr: "<div>डॉक्टर, परिचारिका, पोलीस अधिकारी, सामाजिक कार्यकर्ते व स्वयंसेवक अशा १,४२८ कोरोना योद्ध्यांना फाउंडेशनतर्फे ऑनलाइन प्रशस्तिपत्र देऊन गौरवण्यात आले.</div>",
      headline_en: "1,428 COVID-era volunteers honoured in online felicitation",
      body_en: "<div>Doctors, nurses, police officers, social workers, and volunteers — 1,428 COVID Warriors in all — were honoured by the Foundation with certificates of appreciation presented online.</div>",
      featured: true
    },
    {
      article_type: :initiative, dateline_place: "मुक्ताईनगर", published_at: Date.new(2020, 8, 20),
      headline_mr: "५ महिने २० दिवस चाललेल्या फेसबुक लाइव्ह महाव्याख्यानमालेची विश्वविक्रमात नोंद",
      body_mr: "<div>भारत व परदेशातील १५५ मान्यवर वक्त्यांच्या सहभागाने सलग ५ महिने २० दिवस चाललेल्या या व्याख्यानमालेची द ग्रेट इंडियन बुक ऑफ रेकॉर्ड्समध्ये नोंद झाली. संपादित पुस्तक: प्रबोधनाची ज्ञानदिंडी.</div>",
      headline_en: "Five-month Facebook Live lecture series recognised in national records",
      body_en: "<div>Running continuously for five months and twenty days with 155 speakers from India and abroad, the series was recognised by The Great Indian Book of Records. Edited book: प्रबोधनाची ज्ञानदिंडी.</div>",
      featured: true, activity_slug: "vyakhyanmala"
    }
  ].each do |attrs|
    attrs = attrs.dup
    person_name = attrs.delete(:person_name_mr)
    activity_slug = attrs.delete(:activity_slug)
    headline_en = attrs.delete(:headline_en)
    body_en = attrs.delete(:body_en)
    real_published_at = attrs.delete(:published_at)

    article = Article.joins(:translations)
      .where(article_translations: { locale: "mr", headline: attrs[:headline_mr] }).first

    # Only the article-creation half is guarded by already-seeded --
    # mention lookup/creation runs every time regardless, so a mention
    # doesn't silently stay missing on a second run just because the
    # article itself already existed. (First attempt at this put the
    # mention block inside the `next if already_seeded` guard -- caught
    # by actually re-running db:seed and checking Mention.count came back
    # 0 when it should've been 1, not assumed correct.)
    if article.nil?
      article = Article.new(attrs)
      article.author = seed_author
      article.activity = Activity.find_by(slug: activity_slug) if activity_slug
      article.save!
      article.submit!
      # published_at in the same update as the status change -- the
      # model's after_update_commit callback only fills it in with
      # Time.current when it's still nil, so this preserves the real
      # historical date instead.
      article.update!(status: :published, published_at: real_published_at)
      article.update!(headline_en: headline_en, body_en: body_en)
    end

    if person_name
      # name_mr is a Mobility-translated virtual attribute, not a real
      # column -- find_or_create_by! can't build a WHERE clause against
      # it directly. Person count is small enough that a plain Ruby scan
      # is simpler than Mobility's .i18n query scoping for this one-off.
      person = Person.all.find { |p| p.name_mr == person_name } || Person.create!(name_mr: person_name)
      Mention.find_or_create_by!(article: article, person: person)
    end
  end

  Current.session.destroy
  Current.session = nil
end
