# Strips EXIF (including GPS) from an already-uploaded original blob, in
# place -- same key, same variants still valid, content itself rewritten.
# See app/models/concerns/photoable.rb for why this runs against the
# ORIGINAL, not just derived variants.
#
# UNVERIFIED in this environment -- no libvips here to actually run this
# against a real file. Written to documented image_processing/libvips
# conventions; wants a real check (attach a photo with GPS EXIF, run this
# job, re-inspect the blob) before trusting it for real event photos.
class StripExifJob < ApplicationJob
  queue_as :default

  def perform(blob)
    return unless blob.image?

    blob.open do |file|
      processed = ImageProcessing::Vips
        .source(file)
        .strip
        .call

      blob.upload(File.open(processed.path, "rb"))
    end
  end
end
