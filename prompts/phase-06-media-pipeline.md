# Phase 06 — Media Pipeline

**First: read `docs/06-infrastructure.md` (storage section) and `assets-source/README.md`.**

---

## Goal

Image upload, processing, and delivery through Cloudflare R2. YouTube embeds. Everything after this depends on it working properly.

## Tasks

1. **Cloudflare R2**
   - Bucket `ujjainkar-media`, public read via a custom domain (`media.ujjainkarfoundation.in`)
   - CORS for the app origin
   - Active Storage via the standard S3 adapter with a custom endpoint — config in the infrastructure doc. **No extra gem needed**; R2 is S3-API compatible.
   - `development` uses local disk, `production` uses R2

   R2 rather than S3 because egress, not storage, is the cost driver for a public photo-heavy site — S3 charges roughly $0.09/GB outbound, R2 charges nothing. Rationale in full in the infrastructure doc.

2. **Variants** — libvips via `image_processing`. Widths 400 / 800 / 1600. AVIF primary, WebP fallback, JPEG last resort. Named variants (`:thumb`, `:card`, `:hero`, `:og`) so views never construct transformations inline.

3. **An `image_tag` helper wrapping every content image** with `srcset`, `sizes`, `loading="lazy"`, `decoding="async"`, and explicit `width`/`height`. Layout shift on a photo-heavy site is the main Lighthouse killer.

4. **A shared `Photoable` concern** — `image`, `caption` (translated), `credit`, `position`. `ArticlePhoto` and `EventPhoto` both use it.
   Caption is **content**, translated and displayed. Alt text is separate and derived. Press photos need visible `डावीकडून: ...` captions.

5. **Upload UX in admin** — drag and drop, multiple files, reorder by drag, per-photo caption fields in both locales, client-side preview, progress indication. Assume this is used on a phone at an event venue.

6. **YouTube embeds** — click-to-load facade. Thumbnail plus play button; the YouTube player JS loads only on click. Never self-host video: one 100MB clip going semi-viral on WhatsApp costs more than a year of hosting.

7. **Background processing** — variant generation through Solid Queue so uploads do not block the request.

## Watch for

- Set `force_path_style: true` for R2.
- Validate content type **and** actual file magic bytes, not just the extension.
- Cap upload size (10MB) with a clear Marathi error message.
- Strip EXIF GPS on upload. Photos taken at people's homes or at children's programmes should not carry coordinates.
- Do not pre-shrink originals. Upload full resolution and let the variant pipeline work.

## Definition of done

- [ ] Upload → R2 → variants → delivered as AVIF with fallback
- [ ] `srcset` correct, no layout shift (CLS < 0.1)
- [ ] EXIF GPS stripped, verified on a test file
- [ ] Multi-upload with drag-reorder and bilingual captions works on a phone
- [ ] YouTube facade loads no third-party JS until clicked
- [ ] Committed: `phase-06: media pipeline`
