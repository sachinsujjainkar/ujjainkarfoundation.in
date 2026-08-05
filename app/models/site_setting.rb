# Singleton. Everything still unconfirmed (see docs/00-project-brief.md,
# "Still unconfirmed") lives here so it can be corrected without a deploy --
# never hardcoded in a view. Confirmed values are seeded in db/seeds.rb.
class SiteSetting < ApplicationRecord
  include ImageUploadSafety

  # Homepage hero -- assets-source/README.md documents this as an
  # admin-panel upload (Active Storage), not a static app/assets/images
  # file like the logo, since unlike brand identity it's expected to
  # change. Not part of Photoable: no caption/credit/position, and no
  # existing page needs it at three named sizes the way article/event
  # photos do -- just full-bleed at a handful of widths. Widths/format
  # options mirror Photoable's (see app/models/concerns/photoable.rb) for
  # consistency, sized up for a full-viewport-width hero rather than an
  # in-article image.
  HERO_IMAGE_WIDTHS = [ 800, 1600, 2400 ].freeze

  has_one_attached :hero_image do |attachable|
    HERO_IMAGE_WIDTHS.each do |width|
      Photoable::SAVER_OPTIONS.each do |format, saver|
        attachable.variant :"#{width}_#{format}", resize_to_limit: [ width, nil ], format: format, saver: saver
      end
    end
  end
  image_upload_safety :hero_image, max_size: 15.megabytes

  validate :only_one_record_allowed, on: :create

  # The one row. Creates it with all-nil/false placeholders on first call so
  # every environment (including a fresh test DB) always has a row to read,
  # without needing a seed to have run first.
  def self.instance
    first || create!
  end

  private

  def only_one_record_allowed
    errors.add(:base, "only one SiteSetting may exist") if SiteSetting.exists?
  end
end
