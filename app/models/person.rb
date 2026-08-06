# Does double duty: office bearers (via Membership) and, from Phase 09,
# anyone named in an article. See docs/03-data-model.md.
#
# phone/email are admin-only -- never render them in a public view, never
# include them in JSON, never put them in structured data.
class Person < ApplicationRecord
  include ImageUploadSafety

  extend Mobility
  translates :name, :honorific, :bio, backend: :table

  has_many :memberships, dependent: :destroy
  has_many :committees, through: :memberships

  # From Phase 09 -- anyone named in a published article gets an automatic
  # page listing every mention. See app/models/mention.rb.
  has_many :mentions, dependent: :destroy
  has_many :articles, through: :mentions

  # Founder portrait, committee member photos -- docs/03-data-model.md's
  # `has_one_attached :photo`. Deliberately no named variants here (unlike
  # Photoable's ArticlePhoto/EventPhoto): nothing in the data model or
  # design docs specifies a size matrix for a person portrait, and inventing
  # one ahead of an actual view that renders it would be exactly the kind
  # of unrequested content this project avoids. Add variants when a real
  # page (Phase 09's person page, or the कार्यकारणी listing) needs one.
  has_one_attached :photo
  image_upload_safety :photo

  validates :slug, presence: true, uniqueness: true
  validates :name_mr, presence: true

  before_validation :generate_slug, on: :create

  private

  # Not the numeric-id-prefixed scheme Article uses (docs/01-glossary.md) --
  # that exists specifically for WhatsApp share links, which don't apply to
  # person pages the same way. String#parameterize alone can't be used here:
  # it has no Devanagari transliteration rule and just strips the script
  # entirely, so DevanagariTransliterator does the actual work. Falls back
  # to "vyakti" only if transliteration still produces nothing.
  def generate_slug
    return if slug.present?
    return if name_mr.blank?

    base = DevanagariTransliterator.call(name_mr)
    base = "vyakti" if base.blank?

    candidate = base
    suffix = 1
    while Person.exists?(slug: candidate)
      suffix += 1
      candidate = "#{base}-#{suffix}"
    end
    self.slug = candidate
  end
end
