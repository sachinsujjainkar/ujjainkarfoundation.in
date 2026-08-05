# Pre-generates every named variant (Photoable::VARIANT_WIDTHS x formats,
# plus :og) in the background, via Solid Queue, so the first visitor to
# view a photo isn't the one who pays for on-the-fly processing -- Active
# Storage variants are lazy by default (processed on first access), which
# would otherwise block that visitor's request.
#
# UNVERIFIED end to end in this environment -- no libvips here (see
# app/models/concerns/photoable.rb).
class GenerateImageVariantsJob < ApplicationJob
  queue_as :default

  def perform(record)
    return unless record.image.attached?

    variant_names(record).each do |name|
      record.image.variant(name).processed
    end
  end

  private

  def variant_names(record)
    formats = record.class::SAVER_OPTIONS.keys
    sized = record.class::VARIANT_WIDTHS.keys.product(formats).map { |name, format| :"#{name}_#{format}" }
    og = formats.map { |format| :"og_#{format}" }
    sized + og
  end
end
