# कार्यक्षेत्र -- a standing area of work (शिक्षण, आरोग्य...), not dated. See
# docs/01-glossary.md for the distinction from कार्यक्रम (Event, Phase 10)
# and prompts/phase-08-activities.md for the six locked slugs.
class Activity < ApplicationRecord
  include ImageUploadSafety

  extend Mobility
  translates :name, :tagline, :description, :seo_title, :meta_description, backend: :table

  # Matches app/views/home/_activity_icon.html.erb's case statement exactly
  # -- six keys today, one per confirmed कार्यक्षेत्र. Add both together if a
  # new area or icon ever arrives.
  ICON_KEYS = %w[book award graduation_cap podium document heart].freeze

  has_one_attached :hero_image
  image_upload_safety :hero_image

  has_many :articles, dependent: :nullify
  has_many :events, dependent: :nullify

  validates :slug, presence: true, uniqueness: true
  validates :name_mr, presence: true
  validates :icon_key, inclusion: { in: ICON_KEYS }, allow_nil: true

  default_scope { order(:position) }
  scope :published, -> { where(published: true) }
end
