# Phase 04 — Home Page

**First: read `docs/02-design-system.md` and `docs/00-project-brief.md`.**

---

## Goal

The complete homepage, styled, both locales, placeholder content, grey blocks where photos will go. This is where the design becomes judgeable.

## Sections, in order

1. **Hero** — one full-bleed photograph, one Marathi headline in Tiro Devanagari Marathi at display size, one supporting line, two CTAs (देणगी द्या, स्वयंसेवक बना).
   **No carousel.** A single strong image outperforms a rotating set, loads faster, and does not fight the reader.

2. **आमचा परिणाम** — **three** statistics, not five. Numbers very large in Devanagari numerals, Marathi label beneath, no icons, no sub-labels. Values from `SiteSetting`.
   Five metrics each with icon + number + label + sub-label is doing too much; three set large reads as confident.

3. **कार्यक्षेत्रे** — the focus areas. Monochrome icons in a single accent at varying opacity, or line icons at one weight. **Not five different colours** — that is the template tell this project is specifically avoiding.

4. **ताज्या बातम्या / येणारे कार्यक्रम** — two-column split. News as an asymmetric editorial grid (one lead item larger, then a denser list), events as the date-chip list from the reference mockups. Both patterns are good; keep them.

5. **CTA band** — donate and volunteer, on `--brand-800`.

6. Footer (already built in Phase 03).

## Tasks

- `HomeController#index` with placeholder data — no models yet, so hardcode structs in the controller or use a presenter.
- Every string through i18n. Both locales complete.
- Grey `--line` blocks with dimensions labelled where photos will go. **No AI-generated or stock placeholder images** — they have a way of surviving into production.
- Fully responsive, 360px to 1920px.
- Lighthouse ≥ 90 on mobile for this page before moving on.

## Watch for

- Judge the design against **real-length Marathi text**, not lorem ipsum and not English. Marathi headlines run longer and wrap differently; a hero that looks balanced in English can look broken in Marathi.
- Test the hero headline at 360px. Devanagari display type at three lines is a different composition to two.
- Explicit `width`/`height` on every image slot to prevent layout shift.

## Definition of done

- [ ] All six sections built, both locales
- [ ] Three stats, not five; no icons on them
- [ ] Focus-area icons monochrome, single weight
- [ ] No carousel anywhere
- [ ] Zero AI or stock placeholder imagery
- [ ] Lighthouse mobile ≥ 90
- [ ] Reviewed at 360 / 768 / 1440 in **Marathi** before English
- [ ] Committed: `phase-04: home page`
