# No Activity/Article/Event models yet (Phases 08/09/10) -- placeholder
# structs here, per prompts/phase-04-home-page.md, "hardcode structs in the
# controller." Names/text for the six कार्यक्षेत्रे come from real locale
# keys (config/locales/{mr,en}/activities.yml); the mock news/event
# examples carry both languages directly since they're not real chrome
# vocabulary, just structural placeholder content standing in for Phase
# 09/10's real records. No fabricated statistics, no invented people --
# generic by design; see docs/00-project-brief.md, "Nothing invented ships."
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
        tag: "साहित्य संमेलन",
        headline: "जिल्हास्तरीय साहित्य संमेलन उत्साहात संपन्न, मान्यवरांची लक्षणीय उपस्थिती",
        dateline: "मुक्ताईनगर, दि. १२ जुलै",
        excerpt: "स्थानिक साहित्यिक व नागरिकांच्या उपस्थितीत संमेलनाचे उद्घाटन, विविध सत्रांमध्ये चर्चासत्रे व काव्यवाचन पार पडले."
      ),
      NewsItem.new(
        tag: "पुरस्कार",
        headline: "गुणवंत विद्यार्थ्यांचा सन्मान सोहळा संपन्न",
        dateline: "मुक्ताईनगर, दि. ५ जून",
        excerpt: "शैक्षणिक क्षेत्रातील उल्लेखनीय कामगिरीबद्दल विद्यार्थ्यांना प्रमाणपत्र व सन्मानचिन्ह देऊन गौरवण्यात आले."
      ),
      NewsItem.new(
        tag: "आरोग्य व सामाजिक उपक्रम",
        headline: "आरोग्य तपासणी शिबिराचे यशस्वी आयोजन",
        dateline: "मुक्ताईनगर, दि. २० मे",
        excerpt: "नागरिकांसाठी मोफत आरोग्य तपासणी व मार्गदर्शन शिबिराचे आयोजन करण्यात आले."
      )
    ],
    en: [
      NewsItem.new(
        tag: "Literary Convention",
        headline: "District-level literary convention concludes with strong turnout",
        dateline: "Muktainagar, 12 July",
        excerpt: "Local writers and residents attended the inaugural session, with panel discussions and poetry readings through the day."
      ),
      NewsItem.new(
        tag: "Awards",
        headline: "Meritorious students felicitated at annual ceremony",
        dateline: "Muktainagar, 5 June",
        excerpt: "Certificates and honours were presented to students for notable academic achievement."
      ),
      NewsItem.new(
        tag: "Health & Social Initiatives",
        headline: "Free health screening camp held for residents",
        dateline: "Muktainagar, 20 May",
        excerpt: "A free health check-up and guidance camp was organised for the local community."
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
