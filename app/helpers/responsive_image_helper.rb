module ResponsiveImageHelper
  # Wraps every content image on the site: <picture> with AVIF primary, WebP
  # fallback, JPEG last resort, real srcset across the three named widths
  # (see Photoable::VARIANT_WIDTHS), explicit width/height from the blob's
  # already-analyzed metadata (to avoid layout shift), loading="lazy" and
  # decoding="async".
  #
  # `photoable` is any record that `include Photoable` (ArticlePhoto /
  # EventPhoto, Phase 09/10) -- takes the record rather than a bare
  # attachment because alt text is derived from its translated caption, not
  # passed in separately.
  #
  # UNVERIFIED in this environment: url_for(variant) doesn't eagerly process
  # anything (Active Storage variant URLs redirect to processing on actual
  # request), so the HTML this builds should be structurally correct even
  # without libvips here -- but nobody has actually loaded one of these
  # URLs in a real browser and looked at the network tab. See
  # app/models/concerns/photoable.rb for the fuller caveat.
  def responsive_image_tag(photoable, sizes: "100vw", fallback: :card, **html_options)
    return "".html_safe unless photoable&.image&.attached?

    blob = photoable.image.blob
    alt = derive_alt_text(photoable)

    content_tag :picture do
      safe_join([
        source_tag_for(photoable, :avif, sizes),
        source_tag_for(photoable, :webp, sizes),
        image_tag(
          photoable.image.variant(:"#{fallback}_jpg"),
          alt: alt,
          width: blob.metadata[:width],
          height: blob.metadata[:height],
          loading: "lazy",
          decoding: "async",
          **html_options
        )
      ])
    end
  end

  private

  def source_tag_for(photoable, format, sizes)
    srcset = Photoable::VARIANT_WIDTHS.map do |name, width|
      "#{url_for(photoable.image.variant(:"#{name}_#{format}"))} #{width}w"
    end.join(", ")

    tag.source(srcset: srcset, sizes: sizes, type: "image/#{format}")
  end

  # Caption is content ("डावीकडून: ..." press-caption style, per
  # docs/03-data-model.md); alt text is a plainer derivation of it, not the
  # caption verbatim -- strips the "डावीकडून:"/"From left:" lead-in a screen
  # reader doesn't need.
  def derive_alt_text(photoable)
    caption = photoable.caption
    return "" if caption.blank?

    caption.sub(/\A(डावीकडून|From left)\s*[:：]\s*/, "")
  end
end
