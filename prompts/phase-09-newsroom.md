# Phase 09 — बातम्या (Newsroom)

**First: read `docs/00-project-brief.md`, `docs/01-glossary.md`, and `docs/03-data-model.md` in full.**

The largest and most important phase. This is the reason the site exists.

---

## Goal

A newsroom shaped to how Marathi press writing actually works — not a generic blog with Marathi text in it.

## The model

Full schema in `docs/03-data-model.md`. The fields that matter and why:

- **`subheadline` (उपशीर्षक)** — Marathi newspapers use a kicker line under the headline constantly. Its absence is a large part of why generic CMS output reads as foreign.
- **`dateline_place`** — renders with the date as `पुणे, दि. ५ ऑगस्ट` using the helper from Phase 02. Standard newspaper form.
- **`article_type`** — the six types in the glossary (बैठक वृत्त, पुरस्कार, निवड व नियुक्ती, कार्यक्रम वृत्त, निवेदन, उपक्रम वृत्त). This is the real taxonomy, not generic categories.
- **`mentions` → `Person`** — tag everyone named. Gives an automatic page per person listing every article mentioning them. Nearly free once the join exists, and no peer NGO site has it.
- **`notice_pdf`** — the formal circular that often accompanies an appointment or award.
- **photo captions** — translated content, displayed on the page. `डावीकडून: ...`

## Tasks

1. **Models** — `Article`, `ArticlePhoto`, `Person` (extend from Phase 05), `Mention`. Action Text for body.

2. **Validate Marathi only.** `headline_mr` and `body_mr` required. English optional — that is editorial policy, not an omission.

3. **Workflow** — `draft → submitted → published → archived`.
   - Reporters submit; editors publish
   - Email the editor on submit, the author on publish
   - Publishing sets `published_at` and `published_by_id`
   - Archived articles leave listings but keep resolving at their URL

4. **Slugs** — Latin transliteration from the Marathi headline, generated once on create and then **frozen**. Format `/mr/batmya/1042-shikshan-purskar-vitaran`. Devanagari URLs percent-encode into unreadable strings in WhatsApp, which is the main distribution channel; the numeric prefix guarantees uniqueness and survives headline edits.

5. **Public views**
   - Index with the **asymmetric editorial grid** — one lead item spanning two columns, then a denser list. Not a uniform 3-column card wall.
   - Type filter sidebar (the mockup pattern works; keep it)
   - Detail: dateline, headline, उपशीर्षक, body, photo figures with captions, mentioned people as links, related articles, PDF download, WhatsApp share
   - Pagination

6. **Search** — `pg_trgm` trigram matching. **Postgres full-text dictionaries do not support Marathi**, so `tsvector` is not an option for Devanagari. Trigram works well at this corpus size.

7. **Admin editor** — the piece that determines whether the site stays alive. Marathi labels, no jargon, phone-usable. Type picker, dateline place with recent-values autocomplete, Marathi and English tabs with English clearly optional, person tagging with autocomplete plus create-inline, drag-reorder photos with caption fields, PDF attach, preview before submit, autosave drafts.

8. **`NewsArticle` structured data** — headline, datePublished, author, image, inLanguage. Worth doing properly; it is how the newsroom surfaces in news-style results.

9. **RSS** at `/feed.mr.xml` and `/feed.en.xml`.

## Watch for

- English falling back to Marathi with a notice, never a 404 or an empty page.
- `needs_english_translation` surfaced as a filterable queue in admin.
- Action Text sanitisation configured; reporters will paste from WhatsApp and Word.
- Test the full write-and-submit flow on an actual phone before calling this done.

## Definition of done

- [ ] All four models with translations
- [ ] Full workflow enforced by role, with tests
- [ ] Dateline renders in correct Marathi newspaper form
- [ ] Person tagging works; person pages list all mentions
- [ ] Slugs Latin, frozen after create
- [ ] Trigram search returns sensible Devanagari results
- [ ] `NewsArticle` structured data validates in Google's Rich Results Test
- [ ] English-missing fallback shows the notice, not an error
- [ ] A non-technical person can write and submit an article on a phone unaided
- [ ] Committed: `phase-09: newsroom`
