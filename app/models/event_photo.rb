# Same shape as ArticlePhoto -- docs/03-data-model.md: "Same shape as
# ArticlePhoto, belonging to Event." Both feed the gallery
# (GalleryController), which assembles itself from ArticlePhoto and
# EventPhoto records rather than a separate Album/Gallery model.
class EventPhoto < ApplicationRecord
  include Photoable

  belongs_to :event
end
