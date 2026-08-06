# Same idea as Event#youtube_id (Phase 10) -- a reporter covering a story
# with video (e.g. a speech, a news segment) can embed it via the
# click-to-load facade (components/youtube_embed) without the story
# needing its own Event record.
class AddYoutubeIdToArticles < ActiveRecord::Migration[8.1]
  def change
    add_column :articles, :youtube_id, :string
  end
end
