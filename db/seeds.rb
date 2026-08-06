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

# संस्थापक -- prompts/phase-05-static-pages.md: "founder section with
# portrait and 150-200 words." Content is docs/content/founder/biography.md's
# "Homepage teaser" section (the file's own header comment notes that
# section is sized 150-200 words for exactly this use; the "Full
# biography" sections further down are longer than the phase spec calls
# for here and aren't used by any page yet). Photo intentionally not
# attached -- that file's own "Notes for implementation" says a founder
# photo is still needed. The closing "पंख पिसारा" sentence in bio_mr/bio_en
# below is the one addition beyond that teaser -- per
# docs/content/reference/marathi-wikipedia-2026-08-06.md's "प्रकाशित
# साहित्य" list, confirmed by Sachin, 2026-08-06.
FOUNDER_NAME_MR = "शिवचरण मधुकर उज्जैनकर"
# name_mr is Mobility-translated, not a real column -- find_or_initialize_by
# can't query it directly. Same plain-Ruby-scan pattern as the person
# lookup further down this file.
founder = Person.all.find { |p| p.name_mr == FOUNDER_NAME_MR } || Person.new(name_mr: FOUNDER_NAME_MR)
founder.update!(
  honorific_mr: "डॉ.", honorific_en: "Dr.",
  name_en: "Shivcharan Madhukar Ujjainkar",
  city: "मुक्ताईनगर",
  bio_mr: "ज्याला स्वतःचे शिक्षण पूर्ण करण्यासाठी दुसऱ्यांच्या मदतीची वाट पाहावी लागली, तोच आज हजारो विद्यार्थी आणि साहित्यिकांच्या यशाची वाट मोकळी करत आहे.\n\n" \
    "डॉ. शिवचरण मधुकर उज्जैनकर यांचा जन्म १७ नोव्हेंबर १९६९ रोजी घाटपुरी, खामगाव येथे झाला. वडील मधुकरराव शिवणकाम करत, आई अनुसयाबाई शेतमजुरी करत घर चालवत. या परिस्थितीतही स्व. डॉ. के. एस. सावरकर आणि सौ. रत्नप्रभा सावरकर यांच्या पाठबळावर त्यांनी बी.ए., एम.ए. (इंग्रजी) आणि बी.एड. पूर्ण केले.\n\n" \
    "१९९७ पासून नवीन माध्यमिक विद्यालय, परंबी येथे शिक्षक म्हणून सेवा देत असतानाच त्यांनी अंकुर साहित्य संघ, महर्षी वाल्मिकी मंडळ आणि कवी राम कदम फाउंडेशन (२००९) या संस्था उभारल्या. २०१६ मध्ये या साऱ्या प्रयत्नांचे रूपांतर शिवचरण उज्जैनकर फाउंडेशन मध्ये झाले — जे आज शिक्षण, साहित्य, आरोग्य आणि सामाजिक कार्याचे व्यासपीठ आहे.\n\n" \
    "त्यांचे 'पंख पिसारा' (व्यक्तिचित्र संग्रह) हे पुस्तक प्रकाशित झाले आहे.",
  bio_en: "A man who once relied on others' generosity to complete his own education now clears the path for thousands of students and writers to reach theirs.\n\n" \
    "Dr. Shivcharan Madhukar Ujjainkar was born on 17 November 1969 in Ghatpuri, Khamgaon, to a family of modest means — his father took up tailoring work, his mother worked as a farm labourer. Higher education seemed out of reach until Dr. K. S. Savarkar and Smt. Ratnaprabha Savarkar stepped in, enabling him to complete his B.A., M.A. (English), and B.Ed.\n\n" \
    "Since 1997 he has taught at Navin Madhyamik Vidyalaya, Parambi, while building, alongside his teaching, the Ankur Sahitya Sangh, Maharshi Valmiki Mandal, and the Ram Kadam Foundation (2009). In 2016, these efforts became the Shivcharan Ujjainkar Foundation — now a leading platform for education, literature, health, and community welfare across Maharashtra.\n\n" \
    "He is the author of 'Pankha Pisara', a collection of biographical sketches (व्यक्तिचित्र संग्रह)."
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
      featured: true, person_names_mr: [ "डॉ. सुरेंद्र हेरकळ" ]
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
    },
    # ---- The remaining 11 of docs/content/events.md's 14 candidate
    # stories (#1/#7/#9 are the three above) -- written up in Marathi/
    # English prose from that file's raw facts, nothing added beyond what
    # it gives. None marked featured -- the source only flags story #1 as
    # a standout. No published_at given in the source for any of these,
    # so none is invented here either: left unset, which the model's own
    # after_update_commit callback fills with the real seed-run date
    # (Time.current) rather than a fabricated historical one.
    {
      # Date per Marathi Wikipedia's शिवचरण उज्जैनकर फाउंडेशन article
      # (docs/content/reference/marathi-wikipedia-2026-08-06.md), confirmed
      # by Sachin, 2026-08-06 -- not in docs/content/events.md itself,
      # which gave no date for this story.
      article_type: :event_report, dateline_place: "कुऱ्हा काकोडा", activity_slug: "sahitya-sammelan",
      published_at: Date.new(2010, 5, 8),
      headline_mr: "कुऱ्हा काकोडा येथे ४६ वे अंकुर मराठी साहित्य संमेलन",
      body_mr: "<div>ग्रामीण भागात प्रथमच आयोजित ४६ व्या अंकुर मराठी साहित्य संमेलनाला कुऱ्हा काकोडा येथे उत्स्फूर्त प्रतिसाद मिळाला. ग्रामपंचायत कुऱ्हा काकोडा व कवी राम कदम फाउंडेशन यांच्या संयुक्त विद्यमाने आयोजित या संमेलनासोबतच इयत्ता १०वी व १२वी च्या गुणवंत विद्यार्थ्यांचा सत्कार आणि मोफत मोतीबिंदू तपासणी व शस्त्रक्रिया शिबिरही पार पडले.</div>",
      headline_en: "46th Ankur Marathi Literary Conference held at Kurha Kakoda",
      body_en: "<div>The 46th Ankur Marathi Literary Conference — the first of its kind held in a rural setting — drew an enthusiastic response at Kurha Kakoda. Jointly organised by the Kurha Kakoda Gram Panchayat and the Kavi Ram Kadam Foundation, it was held alongside a felicitation of meritorious Class 10 and 12 students and a free cataract screening and surgery camp.</div>"
    },
    {
      article_type: :event_report, dateline_place: "कुऱ्हा काकोडा", activity_slug: "aarogya-samajik",
      headline_mr: "स्व. अशोक फडके माध्यमिक विद्यालयात आरोग्य शिबिर, ५०० हून अधिक रुग्णांची तपासणी",
      body_mr: "<div>स्व. अशोक फडके माध्यमिक विद्यालय, कुऱ्हा काकोडा येथे आयोजित आरोग्य शिबिरात ५०० हून अधिक रुग्णांची मोफत तपासणी करण्यात आली. डॉ. सदानंद भुसारी (अकोला), डॉ. एन.जी. मराठे व डॉ. गायत्री मराठे (मुक्ताईनगर, हृदयरोग), डॉ. निलेश चांडक (जळगाव, कॅन्सरतज्ज्ञ), डॉ. योगेश पाटील (मुक्ताईनगर, श्रीरोग), डॉ. अंकुश कोलते व डॉ. सुनील मेश्राम (जळगाव, नेत्ररोग व फेको सर्जन) आणि डॉ. गुप्ता (जळगाव) यांनी पाहुणे तज्ज्ञ म्हणून सेवा दिली.</div>",
      headline_en: "Health camp at Late Ashok Phadke Secondary School screens over 500 patients",
      body_en: "<div>A health camp at Late Ashok Phadke Secondary School, Kurha Kakoda, provided free check-ups to more than 500 patients. Guest specialists included Dr. Sadanand Bhusari (Akola), Dr. N.G. Marathe and Dr. Gayatri Marathe (Muktainagar, cardiology), Dr. Nilesh Chandak (Jalgaon, oncology), Dr. Yogesh Patil (Muktainagar), Dr. Ankush Kolte and Dr. Sunil Meshram (Jalgaon, ophthalmology and phaco surgery), and Dr. Gupta (Jalgaon).</div>",
      person_names_mr: [
        "डॉ. सदानंद भुसारी", "डॉ. एन.जी. मराठे", "डॉ. गायत्री मराठे", "डॉ. निलेश चांडक",
        "डॉ. योगेश पाटील", "डॉ. अंकुश कोलते", "डॉ. सुनील मेश्राम", "डॉ. गुप्ता"
      ]
    },
    {
      article_type: :initiative, dateline_place: "मुक्ताईनगर", activity_slug: "aarogya-samajik",
      headline_mr: "मुक्ताईनगर तालुक्यात नेत्र तपासणी व मोतीबिंदू शस्त्रक्रिया मोहीम",
      body_mr: "<div>मुक्ताईनगर तालुक्यात राबवलेल्या नेत्र तपासणी मोहिमेत १,२०० हून अधिक रुग्णांची मोफत नेत्रतपासणी करण्यात आली, तर ३५० हून अधिक रुग्णांवर मोफत मोतीबिंदू शस्त्रक्रिया करण्यात आली.</div>",
      headline_en: "Eye screening and free cataract surgery drive across Muktainagar taluka",
      body_en: "<div>An eye-care drive across Muktainagar taluka provided free eye screenings to over 1,200 patients, with more than 350 receiving free cataract surgery.</div>"
    },
    {
      article_type: :initiative, dateline_place: "मुक्ताईनगर",
      headline_mr: "सुशिक्षित बेरोजगारांसाठी मोफत रोजगार शिबिर, ५४ विद्यार्थ्यांना नोकरी",
      body_mr: "<div>मुक्ताईनगर येथे आयोजित मोफत रोजगार शिबिरातून सुशिक्षित बेरोजगार युवकांना रोजगाराची संधी उपलब्ध करून देण्यात आली. पुणे येथील विविध कंपन्यांमध्ये ५४ विद्यार्थ्यांना विनामूल्य रोजगार मिळवून देण्यात फाउंडेशनला यश आले.</div>",
      headline_en: "Free employment camp for educated unemployed places 54 students",
      body_en: "<div>A free employment camp held at Muktainagar connected educated unemployed youth with job opportunities. The Foundation helped 54 students secure employment, free of cost, with various companies in Pune.</div>"
    },
    {
      article_type: :initiative, dateline_place: "कुऱ्हा काकोडा",
      headline_mr: "कुऱ्हा काकोडा येथे गावरान कुक्कुटपालन शिबिर, २०० शेतकऱ्यांचा सहभाग",
      body_mr: "<div>आधार संस्था, मलकापूर यांच्या सहकार्याने कुऱ्हा काकोडा येथे गावरान कुक्कुटपालन शिबिर आयोजित करण्यात आले. यात २०० शेतकऱ्यांनी सहभाग घेतला. नाबार्ड तज्ज्ञ डॉ. सुदर्शन शेट्टी (मुंबई) यांनी मार्गदर्शन केले.</div>",
      headline_en: "Country-poultry farming workshop at Kurha Kakoda draws 200 farmers",
      body_en: "<div>A country-poultry farming workshop was held at Kurha Kakoda in partnership with Aadhar Sanstha, Malkapur, with 200 farmers taking part. NABARD expert Dr. Sudarshan Shetty (Mumbai) provided guidance.</div>",
      person_names_mr: [ "डॉ. सुदर्शन शेट्टी" ]
    },
    {
      article_type: :award, dateline_place: "मुक्ताईनगर", activity_slug: "puraskar",
      headline_mr: "कोविड काळात सेवा देणाऱ्या १३१ शिक्षकांचा राज्यस्तरीय आदर्श ई-पुरस्काराने सन्मान",
      body_mr: "<div>कोविड काळात समाजसेवा करणाऱ्या १३१ शिक्षकांना फाउंडेशनतर्फे राज्यस्तरीय आदर्श ई-पुरस्काराने सन्मानित करण्यात आले.</div>",
      headline_en: "131 teachers honoured with state-level Adarsh e-Award for COVID-era service",
      body_en: "<div>131 teachers who undertook social service during the COVID period were honoured by the Foundation with a state-level Adarsh e-Award.</div>"
    },
    {
      article_type: :initiative, dateline_place: "मुक्ताईनगर",
      headline_mr: "कै. यशोदाबाई तुळशीराम वावगे फिरते वाचनालय, २९ गावांत मोफत पुस्तक वाटप",
      body_mr: "<div>कै. यशोदाबाई तुळशीराम वावगे यांच्या स्मरणार्थ मुक्ताईनगर तालुक्यातील २९ गावांमध्ये फिरते वाचनालय सुरू करण्यात आले असून, त्याद्वारे शेकडो पुस्तकांचे मोफत वाटप करण्यात येत आहे.</div>",
      headline_en: "Yashodabai Wavge Mobile Library distributes free books across 29 villages",
      body_en: "<div>In memory of Late Yashodabai Tulshiram Wavge, a mobile library now serves 29 villages across Muktainagar taluka, distributing hundreds of books free of charge.</div>"
    },
    {
      article_type: :initiative, dateline_place: "मुक्ताईनगर",
      headline_mr: "'ओळख श्री ज्ञानेश्वरीची' उपक्रम मुक्ताईनगर तालुक्यातील ११ शाळांमध्ये",
      body_mr: "<div>मुक्ताईनगर तालुक्यातील ११ शाळांमध्ये दर शनिवारी 'ओळख श्री ज्ञानेश्वरीची' हा उपक्रम राबवला जात आहे. यामध्ये वडोदा, पारंबी व कुऱ्हा काकोडा येथील शाळांचा समावेश आहे.</div>",
      headline_en: "'Getting to Know Shri Dnyaneshwari' runs across 11 schools in Muktainagar taluka",
      body_en: "<div>Every Saturday, the 'Getting to Know Shri Dnyaneshwari' initiative runs across 11 schools in Muktainagar taluka, including schools at Vadoda, Parambi, and Kurha Kakoda.</div>"
    },
    {
      article_type: :event_report, dateline_place: "कुऱ्हा काकोडा",
      headline_mr: "कुऱ्हा काकोडा गायत्री मंदिरात मान्यवरांचे दोन सत्कार सोहळे",
      body_mr: "<div>कुऱ्हा काकोडा येथील गायत्री मंदिरात दोन सत्कार सोहळे पार पडले — मलकापूर विभागीय पोलीस उपविभागीय अधिकारी तथा कवी श्री चिंतामण शिरोळे यांचा सेवानिवृत्ती सोहळा, आणि ठाणे भूषण कवी राम कदम यांचा ८१ वा वाढदिवस सोहळा.</div>",
      headline_en: "Two felicitation ceremonies held at Gayatri Mandir, Kurha Kakoda",
      body_en: "<div>Two felicitation ceremonies were held at Gayatri Mandir, Kurha Kakoda — a retirement ceremony for Shri Chintaman Shirole, Malkapur divisional deputy police officer and poet, and the 81st birthday celebration of Thane Bhushan poet Ram Kadam.</div>",
      person_names_mr: [ "चिंतामण शिरोळे", "राम कदम" ]
    },
    {
      article_type: :initiative, dateline_place: "काकोडा खोरी",
      headline_mr: "काकोडा खोरी परिसरात तीन वर्षांची वृक्षारोपण मोहीम, ५१ वृक्षांची लागवड",
      body_mr: "<div>काकोडा खोरी परिसरात सलग तीन वर्षे राबवलेल्या वृक्षारोपण मोहिमेत ५१ वृक्षांची लागवड करण्यात आली असून, आजही सर्व वृक्ष सुस्थितीत आहेत.</div>",
      headline_en: "Three-year tree-plantation drive in Kakoda Khori plants 51 trees",
      body_en: "<div>A tree-plantation drive carried out over three consecutive years in the Kakoda Khori area planted 51 trees, all of which remain in good health today.</div>"
    },
    {
      article_type: :award, dateline_place: "जळगाव",
      headline_mr: "'आपला जिल्हा आपले उपक्रम' डिजिटल बुकमध्ये फाउंडेशनच्या कार्याची नोंद",
      body_mr: "<div>'आपला जिल्हा आपले उपक्रम' या डिजिटल बुकमध्ये फाउंडेशनच्या उपक्रमांची नोंद घेण्यात आली. संपादन श्री विजय पवार (उपशिक्षणाधिकारी, प्राथमिक विभाग, जळगाव) यांनी केले असून प्रकाशन श्री नितीन उपासनी (तत्कालीन उपसंचालक, नाशिक विभाग) यांच्या हस्ते झाले.</div>",
      headline_en: "Foundation's work recorded in 'Aapla Jilha Aaple Upakram' digital compendium",
      body_en: "<div>The Foundation's initiatives were recorded in the digital compendium 'Aapla Jilha Aaple Upakram'. It was edited by Shri Vijay Pawar (Deputy Education Officer, Primary Division, Jalgaon) and released by Shri Nitin Upasani (then Deputy Director, Nashik Division).</div>",
      person_names_mr: [ "विजय पवार", "नितीन उपासनी" ]
    }
  ].each do |attrs|
    attrs = attrs.dup
    person_names = Array(attrs.delete(:person_names_mr))
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
      # historical date where one was given, and honestly defaults to
      # the seed-run date otherwise (see the comment above this array).
      article.update!(status: :published, published_at: real_published_at)
      article.update!(headline_en: headline_en, body_en: body_en)
    elsif real_published_at.present? && article.published_at != real_published_at
      # A date arriving AFTER the article's first seed run (as happened
      # for the ४६ वे अंकुर साहित्य संमेलन story once
      # docs/content/reference/marathi-wikipedia-2026-08-06.md supplied
      # one) -- corrects the already-created row rather than only taking
      # effect on a fresh database.
      article.update!(published_at: real_published_at)
    end

    person_names.each do |person_name|
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
