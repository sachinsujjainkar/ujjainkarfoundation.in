# कार्यक्रम -- upcoming (date-chip list) and past (photo grid), derived from
# starts_at, never a stored flag. See docs/03-data-model.md, Phase 10.
class EventsController < ApplicationController
  def index
    @upcoming = Event.published.upcoming.includes(:activity)
    @past = Event.published.past.includes(:activity, :event_photos)
  end

  # find_by! raises ActiveRecord::RecordNotFound on a bad/unpublished slug,
  # deliberately unrescued -- see ActivitiesController#show's identical
  # comment on why.
  def show
    @event = Event.published.includes(:event_photos, :activity, :articles).find_by!(slug: params[:slug])
  end
end
