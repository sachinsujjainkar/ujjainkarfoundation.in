# Shared by ArticlePhoto and EventPhoto (Phase 09/10 -- Article and Event
# don't exist yet, so this concern has no includer in this repo yet; it's
# ready for both to `include Photoable` once their parent models land).
# See docs/03-data-model.md and prompts/phase-06-media-pipeline.md.
#
# Caption is translated CONTENT (press photos need a visible "डावीकडून: ..."
# line), not alt text -- alt text is derived separately, at render time, by
# ResponsiveImageHelper.
#
# IMPORTANT -- unverified in this environment: libvips isn't installed here
# (no package-install permission in this dev container) and no Cloudflare R2
# credentials exist, so variant generation and EXIF stripping haven't been
# exercised end to end. CI does install libvips (.github/workflows/ci.yml)
# so it will be exercised there; it still wants a real manual check against
# a real upload before this is trusted for a real event's photos.
module Photoable
  extend ActiveSupport::Concern

  # docs/02-design-system.md's spec widths, plus a fixed-crop `og` size for
  # the 1200x630 social card (docs/06-infrastructure.md's default OG card).
  VARIANT_WIDTHS = { thumb: 400, card: 800, hero: 1600 }.freeze
  OG_DIMENSIONS = [ 1200, 630 ].freeze

  # AVIF primary, WebP fallback, JPEG last resort -- see
  # ResponsiveImageHelper, which builds the <picture> element in that order.
  # Quality tuned per format: AVIF holds visual quality at a much lower Q
  # than JPEG does, so 50 there is roughly comparable to 85 JPEG at a
  # fraction of the file size.
  SAVER_OPTIONS = {
    avif: { strip: true, Q: 50 },
    webp: { strip: true, Q: 80 },
    jpg: { strip: true, Q: 85 }
  }.freeze

  ALLOWED_CONTENT_TYPES = %w[image/jpeg image/png image/webp].freeze

  class_methods do
    # Sniff magic bytes from a raw upload BEFORE attaching it. Controllers
    # should call this first and reject the upload without ever creating a
    # blob for it -- see the long comment on verify_and_strip_image below
    # for why this can't just be a normal `validate`.
    def acceptable_image_content_type?(io)
      name = io.respond_to?(:original_filename) ? io.original_filename : nil
      Marcel::MimeType.for(io, name: name).in?(ALLOWED_CONTENT_TYPES)
    ensure
      io.rewind if io.respond_to?(:rewind)
    end
  end

  included do
    extend Mobility
    translates :caption, backend: :table

    has_one_attached :image do |attachable|
      VARIANT_WIDTHS.each do |name, width|
        SAVER_OPTIONS.each do |format, saver|
          attachable.variant :"#{name}_#{format}", resize_to_limit: [ width, nil ], format: format, saver: saver
        end
      end
      SAVER_OPTIONS.each do |format, saver|
        attachable.variant :"og_#{format}", resize_to_fill: OG_DIMENSIONS, format: format, saver: saver
      end
    end

    validates :credit, length: { maximum: 200 }
    validates :position, numericality: { only_integer: true }, allow_nil: true

    # Only the size check runs as a normal `validate` -- byte_size is
    # computed synchronously when the blob is unfurled at attach time, so
    # it's available pre-save. Confirmed by testing: right after .attach on
    # an unsaved record, blob.persisted? is false and blob.download raises
    # ActiveStorage::FileNotFoundError -- Active Storage doesn't actually
    # upload the file to the service until the parent record saves. So the
    # magic-byte content-type check (which needs real file bytes) can't
    # reliably run as a pre-save validate for a new attachment.
    validate :image_size_within_limit

    # Defense in depth: verifies content type once the file is actually
    # downloadable (post-commit) and purges anything that slipped through.
    # This is a safety net, not the primary UX -- the primary check belongs
    # in the controller/form, calling acceptable_image_content_type?(io) on
    # the raw upload BEFORE attaching, so a bad file is rejected inline and
    # never even becomes a blob. See Phase 07's admin upload form.
    after_create_commit :verify_content_type_and_strip_exif, if: -> { image.attached? }
  end

  private

  def image_size_within_limit
    return unless image.attached?

    errors.add(:image, :too_large) if image.blob.byte_size > 10.megabytes
  end

  def verify_content_type_and_strip_exif
    blob = image.blob
    acceptable = blob.content_type.in?(ALLOWED_CONTENT_TYPES) &&
      blob.open { |file| self.class.acceptable_image_content_type?(file) }

    unless acceptable
      image.purge_later
      return
    end

    # The variant `strip: true` savers above only strip metadata from
    # derived variants -- the original uploaded blob still carries whatever
    # EXIF (including GPS) the camera wrote. Photos taken at someone's home
    # or a children's programme shouldn't carry coordinates indefinitely.
    StripExifJob.perform_later(blob)

    # Pre-generate every named variant now, in the background, rather than
    # lazily on whichever visitor's request first asks for one.
    GenerateImageVariantsJob.perform_later(self)
  end
end
