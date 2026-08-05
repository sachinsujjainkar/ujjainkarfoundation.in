# Does double duty: office bearers (via Membership) and, from Phase 09,
# anyone named in an article. See docs/03-data-model.md.
#
# phone/email are admin-only -- never render them in a public view, never
# include them in JSON, never put them in structured data.
class Person < ApplicationRecord
  extend Mobility
  translates :name, :honorific, :bio, backend: :table

  has_many :memberships, dependent: :destroy
  has_many :committees, through: :memberships

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
