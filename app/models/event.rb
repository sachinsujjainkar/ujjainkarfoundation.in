# कार्यक्रम -- a dated occurrence (शिबिर, संमेलन...), distinct from Activity's
# undated कार्यक्षेत्र. See docs/01-glossary.md.
class Event < ApplicationRecord
  include ImageUploadSafety

  extend Mobility
  translates :title, :description, :venue_note, backend: :table

  belongs_to :activity, optional: true
  has_many :articles, dependent: :nullify
  has_many :event_photos, -> { order(:position) }, dependent: :destroy

  has_one_attached :hero_image
  image_upload_safety :hero_image

  validates :slug, presence: true, uniqueness: true
  validates :title_mr, presence: true

  # No default_scope -- .upcoming/.past below already set the order that
  # actually matters (nearest-first vs. most-recent-first), and Rails'
  # .order calls append rather than replace, so a default_scope order
  # here would just add redundant/confusing ORDER BY noise on top.
  scope :published, -> { where(published: true) }
  # Upcoming vs past is derived from starts_at, never stored -- docs/03-data-model.md.
  scope :upcoming, -> { where(starts_at: Time.current..).order(starts_at: :asc) }
  scope :past, -> { where(starts_at: ...Time.current).order(starts_at: :desc) }

  before_validation :generate_slug, on: :create

  def upcoming?
    starts_at.present? && starts_at >= Time.current
  end

  private

  # Same transliteration scheme as Person/Activity slugs (a plain name-
  # derived slug, numeric suffix on collision) -- not Article's numeric-
  # id-prefix scheme. docs/04-routes.md writes event URLs as plain
  # "/mr/karyakram/:slug", no id-slug combo.
  def generate_slug
    return if slug.present?
    return if title_mr.blank?

    base = DevanagariTransliterator.call(title_mr)
    base = "karyakram" if base.blank?

    candidate = base
    suffix = 1
    while Event.exists?(slug: candidate)
      suffix += 1
      candidate = "#{base}-#{suffix}"
    end
    self.slug = candidate
  end
end
