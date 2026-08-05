# Phase 02 — i18n Architecture

**First: read `docs/00-project-brief.md` (editorial policy section), `docs/01-glossary.md`, and `docs/04-routes.md`.**

---

## Goal

Marathi-default locale routing, Mobility wired for future models, a language switcher that behaves correctly, and hreflang. Still no pages.

## Tasks

1. **Locale routing**
   - Every public route prefixed: `/mr/...` and `/en/...`. No unprefixed routes — ambiguity here breaks caching, hreflang, and sharing.
   - `/` redirects to `/mr`, or `/en` when `Accept-Language` clearly prefers English **and** no locale cookie is set.
   - `default_url_options` carries the locale so link helpers never lose it.
   - Persist choice in a cookie, one year.

2. **Mobility**
   - `:table` backend — a `_translations` table per model.
   - Locale accessors for `:mr` and `:en`.
   - Fallback `en → mr`, never `mr → en`. If Marathi is missing the record is broken; if English is missing that is normal and expected.

3. **Locale files** — split by area so they stay navigable:
   ```
   config/locales/mr/{common,navigation,forms,articles,events,errors}.yml
   config/locales/en/{...same...}.yml
   ```
   Seed from the canonical strings table in `docs/01-glossary.md`. Use those exact words — consistency across the site matters more than variety.

4. **Language switcher**
   - Maps to the **same record** in the other locale by ID. Never dumps the user on the homepage.
   - On an article with no English translation, `/en/news/1042-...` renders the Marathi article with a small notice: `This article is available in Marathi.` Not a 404, not an empty shell.

5. **hreflang** — reciprocal `mr`/`en` pair plus `x-default` → `/mr`, on every page, in the layout.

6. **Localised formatting**
   - Marathi date format: `५ ऑगस्ट २०२६`
   - Marathi month and weekday names in `date.month_names`
   - A dateline helper producing `पुणे, दि. ५ ऑगस्ट` from a place and a date — Phase 09 depends on it
   - Devanagari numerals in prose (`१,२,३`); Latin numerals in form inputs and admin tables, where they are easier to scan

7. **A locale-completeness test** — fails if any key exists in one locale file and not the other. Cheap to add now, and it will catch drift for years.

## Watch for

- `default_locale = :mr` must already be set from Phase 00.
- Do not enforce translation completeness on **model content**. Marathi required, English optional — that is deliberate editorial policy, not an oversight.
- The `lang` attribute must be correct per element, not just on `<html>`. Mixed-script pages mispronounce badly in screen readers otherwise.

## Definition of done

- [ ] `/mr/...` and `/en/...` both resolve; `/` redirects sensibly
- [ ] Switching locale on a detail page stays on that record
- [ ] hreflang + x-default present and reciprocal
- [ ] Marathi dates render in Devanagari with Marathi month names
- [ ] Dateline helper works
- [ ] Locale-parity test passes
- [ ] Committed: `phase-02: i18n architecture`
