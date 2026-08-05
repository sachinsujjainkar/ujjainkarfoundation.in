# Project Brief — उज्जैनकर फाउंडेशन

Read this before any phase. Every prompt in `prompts/` assumes it.

---

## What this is

A **bilingual newsroom-backed website** for a registered non-profit foundation. Not a brochure site, not a member portal.

The foundation already produces content: meeting reports, award announcements, nomination notices, event coverage — the material it currently sends to local Marathi newspapers. This site becomes the primary place that content is published, with the newspapers as a secondary channel.

---

## Who uses it

**Public visitors (95%+ of traffic).** Overwhelmingly Marathi-reading, mobile, arriving from WhatsApp forwards rather than search. Optimise for: fast first paint on a mid-range Android over 4G, readable Devanagari at arm's length, one-tap share back to WhatsApp.

**Donors and institutions (small but high-value).** CSR desks, government offices, grant bodies. They read English, and they look for registration number, 12A/80G status, audited statements, and named office bearers. This is what the English side of the site is actually for.

**Staff (3–6 people).** The appointed media person writes; a senior editor approves; an admin manages everything. Phone-first admin — assume posts get written on a phone from an event venue.

**There is no public registration.** No sign-up page exists. All accounts are created by hand by the admin.

---

## The three things that make this site not ordinary

If time runs short, protect these. Everything else is replaceable.

1. **Devanagari typography done properly.** Almost every Marathi NGO site renders in a default system font at Latin metrics and looks cheap as a result. Correct fonts, correct line-height, correct size ratio — this alone lifts the whole site. See `docs/02-design-system.md`.

2. **The newsroom model fits actual Marathi press writing.** उपशीर्षक, dateline, व्यक्ती उल्लेख tagging, photo captions. A generic blog post model would work but would feel foreign to whoever is writing.

3. **The poster generator.** One click turns a published article into a WhatsApp-ready graphic. This is what gets the foundation's output actually circulating, and no peer NGO has it.

---

## Editorial policy — bilingual without forcing translation

- **Marathi is the source of record.** Every article requires Marathi. The `mr` locale is the application default.
- **English is optional per article.** If English fields are empty, the English site shows the Marathi article with a small notice, not a 404 or an empty shell.
- **Site chrome is always fully bilingual.** Navigation, buttons, form labels, validation messages, error pages. These are fixed YAML, translated once.
- **English is used deliberately** on About, Donate, Transparency, annual reports, and major announcements — the pages donors and institutions read.
- Articles carry a `needs_english_translation` flag so someone can pick up the queue without blocking publishing.

---

## Roles

| Role | Marathi | Can |
|---|---|---|
| `admin` | प्रशासक | Everything: settings, users, deletion |
| `editor` | संपादक | Publish, unpublish, edit anyone's work |
| `reporter` | वार्ताहर | Create and edit own drafts, submit for review |

A simple enum on `User`. No permissions gem. The valuable part is the **draft → submitted → published** flow: an award or appointment announcement is a document of record, so a second pair of eyes before it goes live is worth the friction.

---

## Stack (settled — do not substitute)

- Rails 8, Ruby 3.3+, PostgreSQL 16
- Hotwire (Turbo + Stimulus). No React, no separate frontend.
- Tailwind CSS
- Solid Queue / Solid Cache / Solid Cable (Rails 8 built-ins — no Redis)
- Mobility for translatable model content; Rails i18n YAML for UI chrome
- Avo 3 for admin (do not hand-roll a dozen CRUD screens)
- Active Storage + Cloudflare R2
- Deployed on Railway; Cloudflare in front for DNS, SSL, CDN

Full infrastructure detail in `docs/06-infrastructure.md`.

---

## Hard constraints

- **Maintainable by one developer**, indefinitely, with long gaps between touches. Favour boring Rails over clever Rails.
- **Budget ~₹1,200–1,800/month** all-in.
- **The content risk is bigger than the build risk.** The common failure mode for NGO sites is that nobody posts after month two. The admin must be simple enough that a non-technical media person will actually use it: Marathi labels, no jargon, works on a phone.
- **Nothing invented ships.** No placeholder addresses, phone numbers, statistics, or founder details in production. All such values live in `SiteSetting` or locale YAML, editable without a deploy.

---

## Still unconfirmed

Do not guess these. Flag and use an obvious placeholder if you hit one.

1. City and district of operation. Earlier mockups said Ujjain, Madhya Pradesh; "उज्जैनकर" is a Marathi surname and the foundation may well be in Maharashtra.
2. Trust or Society; registration number and date.
3. 12A / 80G status.
4. Final कार्यक्षेत्रे list (assuming शिक्षण, आरोग्य, पर्यावरण, अन्न वितरण, महिला सक्षमीकरण).
5. Founder name and details.
6. Real impact statistics.
