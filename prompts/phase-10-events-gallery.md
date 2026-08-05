# Phase 10 — कार्यक्रम & गॅलरी

**First: read `docs/01-glossary.md`, `docs/03-data-model.md`, and `docs/04-routes.md`.**

---

## Goal

Events (upcoming and past) and a gallery that maintains itself.

## Part A — कार्यक्रम

1. `Event` model per the data model doc. Upcoming vs past derived from `starts_at`, never stored as a flag.

2. **Index** `/mr/karyakram` — आगामी कार्यक्रम as the date-chip list from the reference mockups (that pattern is good), then झालेले कार्यक्रम as a photo grid.

3. **Detail** — hero, date and time, venue with map, description, photo gallery, YouTube embed if present, linked coverage articles.

4. **Registration is Phase 2.** Not in this build. Do not add a half-built form.

5. Avo resource with a date picker, activity association, and photo management.

## Part B — गॅलरी

**No `Album` model.** The gallery assembles itself from existing `ArticlePhoto` and `EventPhoto` records, grouped by कार्यक्षेत्र and by year. One upload point, two display surfaces, nothing maintained twice.

1. `/mr/dalan` — filterable by कार्यक्षेत्र and year, masonry or justified grid, lazy loaded, infinite scroll or paginated.

2. **Lightbox** — keyboard navigable (arrows, Escape), shows the Marathi caption and credit, swipeable on touch. No heavy library; a Stimulus controller is enough.

3. `/mr/dalan/:year` — year archives.

4. **चित्रफिती** tab — YouTube videos from events, click-to-load facade.

Add a standalone `Album` model **only** if historical photo archives predating the site turn up. Confirm with the foundation before building it.

## Watch for

- The gallery can grow to thousands of images. Paginate at the query level, do not load all IDs.
- Captions are the point. A gallery of uncaptioned photos is a screensaver; a gallery where every photo names the people and the occasion is a record.

## Definition of done

- [ ] Event model, index, detail, both locales
- [ ] Upcoming/past derived, not stored
- [ ] Gallery auto-assembles from article and event photos
- [ ] Lightbox keyboard and touch navigable, captions shown
- [ ] No `Album` model
- [ ] Committed: `phase-10: events and gallery`
