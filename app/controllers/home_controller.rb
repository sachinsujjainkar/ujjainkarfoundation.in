# Article is real as of Phase 09 -- @news_items comes straight from the
# database now, the three real launch articles seeded in db/seeds.rb
# (formerly a NewsItem struct placeholder here, per that seed block's own
# comment). Activity has been real since Phase 08. Event doesn't exist
# until Phase 10, so EventItem stays a placeholder struct below.
class HomeController < ApplicationController
  EventItem = Struct.new(:day, :month, :title, :venue, :status, keyword_init: true)

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
    @activities = Activity.published
    @news_items = Article.published.order(published_at: :desc).limit(3)
    @events = EVENTS.fetch(I18n.locale)
  end
end
