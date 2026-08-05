# Content intake — staging, not a CMS

This directory holds **real facts about the foundation and founder**, written down once so they can be transcribed accurately into the app instead of invented. It is not read by the running application anywhere — nothing here is a template, a partial, or a data source Rails loads. It exists purely so Sachin can hand over real content in an organized way, and so I (or anyone building a later phase) can pull from it instead of guessing.

Where each file actually ends up, once transcribed:

- `foundation/*.md`, `founder/*.md` → mostly hand-written page copy in `config/locales/{mr,en}/*.yml` (आमच्याविषयी) and fields on the `Person` record for the founder (Phase 05/06 already built; content was left as honest placeholders pending this).
- `programmes/*.md` → seed data for the six `Activity` records, Phase 08 — file names match the locked slugs in `prompts/phase-08-activities.md` exactly.
- `organisation/committees.md` → seed data for `Committee`/`Membership`/`Person` records, Phase 05 (`docs/content/committees.md` is already referenced by that prompt).
- `events.md` → seed data for `Event` records (Phase 10) and first `Article` entries (Phase 09, per `prompts/phase-09-newsroom.md`).
- `media/press.md` → background/links for early `Article` seed content (Phase 09). Actual photo *files* don't belong in this repo at all — those go to Cloudflare R2 through the admin upload UI once Phase 07 exists.
- `organisation/districts.md` → doesn't map onto anything in `docs/03-data-model.md` yet. Left open deliberately — capture whatever's real here, and we'll decide the right home (a `SiteSetting` field? a real model?) once there's actual content to look at, rather than inventing a schema for it now.

See `docs/05-content-checklist.md` for the canonical list of what's blocking which phase — these files are organized by topic, that one's organized by urgency. Cross-check against it before phase-05/06/09-adjacent work.

**Nothing invented ships** (see `docs/00-project-brief.md`). If a file below is empty or partial when its phase comes up, the page ships with an honest "pending" state — not a guess.
