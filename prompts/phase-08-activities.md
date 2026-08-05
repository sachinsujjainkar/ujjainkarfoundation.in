# Phase 08 — कार्यक्षेत्रे (Focus Areas)

**First: read `docs/01-glossary.md` and `docs/03-data-model.md`.**

---

## Goal

The `Activity` model and its public pages. Small phase — it is the warm-up for the newsroom.

## Terminology, locked

**कार्यक्षेत्र** = a standing area of work (शिक्षण, आरोग्य). Not dated.
**कार्यक्रम** = a dated event. Phase 10.

Earlier drafts used उपक्रम loosely for both. That ambiguity is resolved: उपक्रम is not an entity name anywhere in this codebase.

## Tasks

1. `Activity` model per the data model doc. Mobility on `name`, `tagline`, `description`, SEO fields.

2. **Index** `/mr/karyakshetre` — grid of activity cards. Monochrome icons at a single weight. Not five colours.

3. **Detail** `/mr/karyakshetre/:slug` — hero image, description, and (once Phases 09–10 land) related articles and events pulled by `activity_id`. Build the sections now with empty states so they light up automatically later.

4. **Avo resource** with the icon picker, ordering, and publish toggle.

5. **Seed data** — the six confirmed areas, with slugs:

   | कार्यक्षेत्र | slug |
   |---|---|
   | साहित्य संमेलन | `sahitya-sammelan` |
   | पुरस्कार | `puraskar` |
   | विद्यार्थी सत्कार | `vidyarthi-satkar` |
   | व्याख्यानमाला | `vyakhyanmala` |
   | प्रकाशन | `prakashan` |
   | आरोग्य व सामाजिक उपक्रम | `arogya-va-samajik-upakram` |

6. **Icon set** — commission or select 8–10 monochrome line icons, single weight, as SVG in `assets-source/icons/`. Consistency of weight across the set matters more than the individual icons.

## Definition of done

- [ ] Model, migrations, Mobility translations
- [ ] Index and detail pages, both locales
- [ ] Icons monochrome and consistent in weight
- [ ] Empty states for the not-yet-existing related content
- [ ] Avo resource with ordering
- [ ] Committed: `phase-08: activities`
