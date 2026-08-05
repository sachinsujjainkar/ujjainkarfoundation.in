# Shared by any model with a directly-uploaded image attachment: the size
# cap, the post-save magic-byte content-type re-check, and the EXIF-strip
# hand-off. Extracted out of Photoable (Phase 06) when Person gained its own
# `photo` attachment, so the two don't duplicate this logic -- see
# docs/03-data-model.md for what each model actually declares.
#
# Usage: `include ImageUploadSafety`, then call `image_upload_safety :photo`
# (or whatever the attachment is named) in the class body, after the
# `has_one_attached` declaration.
module ImageUploadSafety
  extend ActiveSupport::Concern

  ALLOWED_CONTENT_TYPES = %w[image/jpeg image/png image/webp].freeze

  class_methods do
    # Sniff magic bytes from a raw upload BEFORE attaching it. Controllers
    # should call this first and reject the upload without ever creating a
    # blob for it -- see the long comment on verify_image_content_type_and_strip_exif
    # below for why this can't just be a normal `validate`.
    def acceptable_image_content_type?(io)
      name = io.respond_to?(:original_filename) ? io.original_filename : nil
      Marcel::MimeType.for(io, name: name).in?(ALLOWED_CONTENT_TYPES)
    ensure
      io.rewind if io.respond_to?(:rewind)
    end

    # Declares the validation + safety-net callback for one has_one_attached
    # image on this model. Call after the has_one_attached declaration.
    #
    # Pass a block to run extra work (instance_exec'd on the record) once
    # the upload is verified acceptable and EXIF stripping has been
    # enqueued -- Photoable uses this to also enqueue variant generation,
    # which a plain single-size attachment like Person#photo has no need
    # for.
    def image_upload_safety(attachment_name, max_size: 10.megabytes, &on_verified)
      attachment_name = attachment_name.to_sym

      # Only the size check runs as a normal `validate` -- byte_size is
      # computed synchronously when the blob is unfurled at attach time, so
      # it's available pre-save. Confirmed by testing: right after .attach
      # on an unsaved record, blob.persisted? is false and blob.download
      # raises ActiveStorage::FileNotFoundError -- Active Storage doesn't
      # actually upload the file to the service until the parent record
      # saves. So the magic-byte content-type check (which needs real file
      # bytes) can't reliably run as a pre-save validate for a new
      # attachment.
      validate do
        attachment = public_send(attachment_name)
        next unless attachment.attached?

        errors.add(attachment_name, :too_large) if attachment.blob.byte_size > max_size
      end

      # Defense in depth: verifies content type once the file is actually
      # downloadable (post-commit) and purges anything that slipped
      # through. This is a safety net, not the primary UX -- the primary
      # check belongs in the controller/form, calling
      # acceptable_image_content_type?(io) on the raw upload BEFORE
      # attaching, so a bad file is rejected inline and never even becomes
      # a blob. See Phase 07's admin upload form.
      after_create_commit(if: -> { public_send(attachment_name).attached? }) do
        attachment = public_send(attachment_name)
        blob = attachment.blob
        acceptable = blob.content_type.in?(ALLOWED_CONTENT_TYPES) &&
          blob.open { |file| self.class.acceptable_image_content_type?(file) }

        if acceptable
          # The variant `strip: true` savers (where a model defines named
          # variants -- see Photoable) only strip metadata from derived
          # variants -- the original uploaded blob still carries whatever
          # EXIF (including GPS) the camera wrote. Photos taken at
          # someone's home or a children's programme shouldn't carry
          # coordinates indefinitely.
          StripExifJob.perform_later(blob)
          instance_exec(&on_verified) if on_verified
        else
          attachment.purge_later
        end
      end
    end
  end
end
