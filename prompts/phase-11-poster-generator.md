# Phase 11 — Poster Generator

**First: read `docs/02-design-system.md`.**

The standout feature. This is what gets the foundation's output actually circulating.

---

## Goal

One click turns a published article into a WhatsApp-ready graphic.

## The critical technical constraint

**Render client-side, in the browser.**

Server-side image generation with ImageMagick mangles Devanagari conjuncts — क्ष, ज्ञ, र्‍य and similar render broken or as separate glyphs. The browser's text shaping (HarfBuzz) is correct, free, and gives live preview.

**Approach:** compose the poster as HTML/CSS inside a Stimulus controller, then rasterise with `html-to-image` or a canvas library, and trigger download.

If a scheduled or bulk server-side path is ever genuinely needed, use libvips `text()` or ImageMagick's `pango:` delegate — both route through Pango/HarfBuzz and shape correctly. Plain ImageMagick `-annotate` does not. But do not build that now.

## Tasks

1. **Templates** — five to start:
   - बातमी announcement (headline + photo + logo)
   - कार्यक्रम invitation (title, date, venue, map hint)
   - पुरस्कार / अभिनंदन card
   - Festival greeting (गुढी पाडवा, गणेशोत्सव, शिवजयंती, स्वातंत्र्य दिन)
   - Quote card

2. **Two sizes** — 1080×1080 (feed) and 1080×1920 (status). WhatsApp Status is the higher-value one; do not treat it as an afterthought.

3. **From an article** — an admin button on any published article pre-fills headline, date, featured photo, and logo into the chosen template. The user adjusts and downloads.

4. **Editor** — template picker, live preview, editable text, photo crop/reposition, template colour variants within the brand palette.

5. **Typography** — same fonts as the site, Tiro Devanagari Marathi for the headline. Fonts must be fully loaded before rasterising or the export silently falls back to a system font. Use `document.fonts.ready`.

6. **Export** — PNG at 2× for crispness, under 1MB so WhatsApp does not recompress it into mush. Filename from the article slug.

7. **Direct WhatsApp share** where the Web Share API is available; download as fallback.

## Watch for

- **Verify conjunct rendering explicitly.** Put `क्ष ज्ञ त्र श्र द्य र्‍या` in a test poster and inspect the exported PNG at full size. This is the single failure mode this whole approach exists to avoid.
- Long Marathi headlines need auto-fitting — measure and step the font size down, with a sensible floor.
- Logo must be the vector, never a rasterised copy.
- Test on an actual Android phone; canvas rasterisation behaves differently to desktop Chrome.

## Definition of done

- [ ] Five templates, both sizes
- [ ] One-click generation from a published article
- [ ] **Conjuncts verified correct in exported PNG** — क्ष ज्ञ त्र श्र
- [ ] Fonts confirmed loaded before rasterise
- [ ] Export under 1MB, sharp at full size
- [ ] Works on a real Android phone
- [ ] Committed: `phase-11: poster generator`
