# Article has been real since Phase 09, Activity since Phase 08. Event is
# real as of Phase 10 -- @events comes straight from the database now
# (formerly an EventItem struct placeholder here, per that struct's own
# former comment).
class HomeController < ApplicationController
  def index
    @activities = Activity.published
    @news_items = Article.published.order(published_at: :desc).limit(3)
    @events = Event.published.upcoming.includes(:activity).limit(3)
  end
end
