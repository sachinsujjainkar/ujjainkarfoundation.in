# गॅलरी -- no Gallery/Album model, assembles itself from ArticlePhoto and
# EventPhoto via GalleryPhoto's union query. See
# prompts/phase-10-events-gallery.md, "Part B".
class GalleryController < ApplicationController
  PHOTO_TAB = "photos"
  VIDEO_TAB = "videos"

  # /mr/dalan and /mr/dalan/:year (gallery_year route, config/routes.rb)
  # both land here -- :year just narrows the same filtered feed.
  def index
    @activities = Activity.published
    @selected_activity = Activity.published.find_by(slug: params[:karyakshetra]) if params[:karyakshetra].present?
    @years = GalleryPhoto.years
    @selected_year = (params[:year].presence || params[:filter_year].presence)&.to_i

    @tab = params[:tab] == VIDEO_TAB ? VIDEO_TAB : PHOTO_TAB

    if @tab == VIDEO_TAB
      # चित्रफिती -- YouTube videos from events, click-to-load facade
      # (components/youtube_embed). Not paginated at query-level like the
      # photo grid -- events with a linked video are a small, bounded set
      # compared to "thousands of images", so a plain ordered list is
      # honest here rather than building pagination this data doesn't need.
      @videos = Event.published.where.not(youtube_id: [ nil, "" ]).order(starts_at: :desc)
    else
      @pagy, @photos = GalleryPhoto.page(
        activity_id: @selected_activity&.id,
        year: @selected_year,
        page: params[:page]
      )
    end
  end
end
