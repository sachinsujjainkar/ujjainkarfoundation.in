# No Activity/Article/Event models yet (Phases 08/09/10) -- placeholder
# structs here, per prompts/phase-04-home-page.md, "hardcode structs in the
# controller." Names/text for the six कार्यक्षेत्रे come from real locale
# keys (config/locales/{mr,en}/activities.yml).
#
# NEWS_ITEMS is real, not generic: three candidate stories from
# docs/content/events.md (Sachin, 2026-08-05), written up as short news
# blurbs from the confirmed facts there -- exactly what that file's own
# note anticipated ("hardcoded as placeholder cards in Phase 04... become
# real Article records once Phase 09 lands"). Every figure/date/name below
# traces back to that file; nothing here is invented.
#
# EVENTS is still generic structural placeholder -- no real dated upcoming
# event exists yet (the one real one, आगामी संमेलन, has confirmed venues
# but no confirmed date, so it gets its own honest-pending panel below
# rather than a fake day/month here). See docs/00-project-brief.md,
# "Nothing invented ships."
class HomeController < ApplicationController
  Activity = Struct.new(:slug, :icon, keyword_init: true)
  NewsItem = Struct.new(:headline, :dateline, :excerpt, :tag, keyword_init: true)
  EventItem = Struct.new(:day, :month, :title, :venue, :status, keyword_init: true)

  ACTIVITIES = [
    Activity.new(slug: "sahitya_sammelan", icon: :book),
    Activity.new(slug: "puraskar", icon: :award),
    Activity.new(slug: "vidyarthi_satkar", icon: :graduation_cap),
    Activity.new(slug: "vyakhyanmala", icon: :podium),
    Activity.new(slug: "prakashan", icon: :document),
    Activity.new(slug: "arogya_va_samajik_upakram", icon: :heart)
  ].freeze

  NEWS_ITEMS = {
    mr: [
      NewsItem.new(
        tag: "सामाजिक उपक्रम",
        headline: "आळंदीत ७५० फूट लांबीची विश्वविक्रमी राखी संत ज्ञानेश्वर माऊलींना अर्पण",
        dateline: "आळंदी, दि. ४ जानेवारी २०२५",
        excerpt: "आदिशक्ती संत मुक्ताई कडून संतश्रेष्ठ श्री ज्ञानेश्वर माऊलींना अर्पण करण्यात आलेल्या ७५० फूट लांब व ७५ किलो वजनाच्या राखीची हेरिटेज बुक ऑफ वर्ल्ड रेकॉर्ड्समध्ये नोंद झाली. संकल्पना प्राचार्य डॉ. सुरेंद्र हेरकळ यांची."
      ),
      NewsItem.new(
        tag: "पुरस्कार",
        headline: "कोरोना काळात सेवा देणाऱ्या १,४२८ समाजसेवकांचा ऑनलाइन सन्मान",
        dateline: "लॉकडाऊन काळात",
        excerpt: "डॉक्टर, परिचारिका, पोलीस अधिकारी, सामाजिक कार्यकर्ते व स्वयंसेवक अशा १,४२८ कोरोना योद्ध्यांना फाउंडेशनतर्फे ऑनलाइन प्रशस्तिपत्र देऊन गौरवण्यात आले."
      ),
      NewsItem.new(
        tag: "व्याख्यानमाला",
        headline: "५ महिने २० दिवस चाललेल्या फेसबुक लाइव्ह महाव्याख्यानमालेची विश्वविक्रमात नोंद",
        dateline: "कोविड लॉकडाऊन काळात",
        excerpt: "भारत व परदेशातील १५५ मान्यवर वक्त्यांच्या सहभागाने सलग ५ महिने २० दिवस चाललेल्या या व्याख्यानमालेची द ग्रेट इंडियन बुक ऑफ रेकॉर्ड्समध्ये नोंद झाली."
      )
    ],
    en: [
      NewsItem.new(
        tag: "Social Initiative",
        headline: "750-foot record-setting rakhi offered to Sant Dnyaneshwar Mauli in Alandi",
        dateline: "Alandi, 4 January 2025",
        excerpt: "A 750-foot, 75-kilogram rakhi, offered on behalf of Adishakti Sant Muktai to Sant Dnyaneshwar Mauli, was recorded in the Heritage Book of World Records. The initiative was conceived by Principal Dr. Surendra Herkal."
      ),
      NewsItem.new(
        tag: "Award",
        headline: "1,428 COVID-era volunteers honoured in online felicitation",
        dateline: "During the lockdown period",
        excerpt: "Doctors, nurses, police officers, social workers, and volunteers — 1,428 COVID Warriors in all — were honoured by the Foundation with certificates of appreciation presented online."
      ),
      NewsItem.new(
        tag: "Lecture Series",
        headline: "Five-month Facebook Live lecture series recognised in national records",
        dateline: "During the COVID lockdown",
        excerpt: "Running continuously for five months and twenty days with 155 speakers from India and abroad, the series was recognised by The Great Indian Book of Records."
      )
    ]
  }.freeze

  EVENTS = {
    mr: [
      EventItem.new(day: "१५", month: "सप्टें", title: "व्याख्यानमाला — सत्र १", venue: "सभागृह, मुक्ताईनगर", status: :upcoming),
      EventItem.new(day: "२८", month: "सप्टें", title: "ग्रंथ प्रकाशन सोहळा", venue: "सभागृह, मुक्ताईनगर", status: :upcoming)
    ],
    en: [
      EventItem.new(day: "15", month: "Sep", title: "Lecture Series — Session 1", venue: "Hall, Muktainagar", status: :upcoming),
      EventItem.new(day: "28", month: "Sep", title: "Book Publication Ceremony", venue: "Hall, Muktainagar", status: :upcoming)
    ]
  }.freeze

  def index
    @activities = ACTIVITIES
    @news_items = NEWS_ITEMS.fetch(I18n.locale)
    @events = EVENTS.fetch(I18n.locale)
  end
end
