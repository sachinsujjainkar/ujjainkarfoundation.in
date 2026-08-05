# Phase 01 — Design System

**First: read `docs/02-design-system.md` in full, then `docs/00-project-brief.md`.**

This phase decides whether the site looks distinctive or templated. Take the time.

---

## Goal

Fonts, palette, type scale, and every component primitive — rendered in both scripts on a styleguide page. No pages yet.

## Tasks

1. **Fonts, self-hosted**
   - Download **Tiro Devanagari Marathi** (the Marathi cut specifically — not the Sanskrit cut; the ल and श forms differ and Marathi readers notice), **Mukta** 400/600/700, **Source Serif 4**, **Inter** 400/600/700.
   - Subset to the ranges actually used, convert to woff2, serve from `app/assets/fonts/`.
   - `<link rel="preload">` the two body weights only.
   - `font-display: swap`.
   - **Do not** load from the Google Fonts CDN at runtime — the audience is on mid-range Android over 4G.

2. **Tailwind config** — every token from the design doc as a CSS custom property, then mapped into Tailwind theme. Colours, spacing scale (`4 8 12 16 24 32 48 64 96 128`), radii, the two type scales.

3. **Locale-aware typography.** Two type scales switched by the `lang` attribute. Devanagari runs one step larger with looser leading throughout — exact values in the design doc.

4. **Guard the Devanagari rules.** Add a stylelint rule, or at minimum a prominent comment block, forbidding `letter-spacing`, `text-transform: uppercase`, and `font-stretch` on any Devanagari selector. These break conjuncts (क्ष, ज्ञ, त्र) or describe a concept the script does not have. They are the most common mistakes and are immediately visible to a native reader.

5. **Components** — build each as a partial with all states (default, hover, focus-visible, disabled, loading, error):

   `btn-primary` `btn-secondary` `btn-ghost` `card` `card-article` `card-event`
   `page-header` `breadcrumb` `tag` `stat` `form-field` `select` `textarea`
   `checkbox` `pagination` `empty-state` `flash` `photo-figure`
   `share-whatsapp` `lang-switch`

6. **`/styleguide`** — development environment only. Every component rendered **twice, side by side, Marathi and English**. This is how you catch that the two scripts look wrong at the same nominal size, and it is much cheaper to fix here than after forty views exist.

## Design guardrails

- One accent colour per screen. The ochre is for the single most important CTA — not for five different icons.
- No gradients.
- No multicoloured icon sets. Monochrome line icons, single weight, or one colour at varying opacity. Multicoloured focus-area icons are the classic AI-mockup tell.
- `--paper` and `--ink`, never `#FFF` or `#000`.
- Cards: `8px` radius, `1px` border, no resting shadow.
- Marathi body copy measure: 60–70 characters.

## Definition of done

- [ ] Fonts self-hosted, subsetted, preloaded; no external font requests in the network tab
- [ ] `/styleguide` renders every component in both scripts
- [ ] Zero `letter-spacing` or `uppercase` on any Devanagari selector
- [ ] Every colour pairing checked to ≥ 4.5:1 body / ≥ 3:1 large
- [ ] `:focus-visible` ring on every interactive element; no `outline: none` anywhere
- [ ] Committed: `phase-01: design system`
