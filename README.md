# उज्जैनकर फाउंडेशन — Build Pack

Everything needed to build ujjainkarfoundation.in with Claude Code, one phase at a time.

---

## How to use this pack

1. Drop this whole folder into your project directory.
2. Read `docs/00-project-brief.md` once. Everything else assumes it.
3. Run prompts in order, `prompts/phase-00` through `prompts/phase-12`.
4. **One prompt per Claude Code session.** Paste the whole file. Do not run two phases in one session — context bleeds and quality drops.
5. After each phase, run the "Definition of done" checklist at the bottom of that prompt before moving on.

Every prompt begins with a line telling Claude Code to read `docs/00-project-brief.md`, `docs/01-glossary.md`, and `docs/02-design-system.md` first. Do not remove that line — those three files are the shared context that keeps phases consistent.

---

## Phase index

| # | Phase | Output | Est. |
|---|-------|--------|------|
| 00 | Foundation & setup | Rails 8 app, gems, CI, deploys to Railway | 2 days |
| 01 | Design system | Fonts, palette, type scale, Tailwind config, component primitives | 4 days |
| 02 | i18n architecture | `mr` default, locale routing, Mobility, hreflang | 3 days |
| 03 | Layout shell | Header, nav, language switcher, footer, breadcrumbs, page header | 3 days |
| 04 | Home page | Full homepage, placeholder content, grey image blocks | 4 days |
| 05 | Static pages | About, Contact, Volunteer, Donate, Transparency, 404/500 | 4 days |
| 06 | Media pipeline | Active Storage + Cloudflare R2, variants, AVIF/WebP, YouTube embeds | 3 days |
| 07 | Admin & auth | Staff-only login, three roles, Avo dashboard in Marathi | 4 days |
| 08 | कार्यक्षेत्रे (Activities) | Activity model, index, detail pages | 2 days |
| 09 | बातम्या (Newsroom) | Article model, dateline, उपशीर्षक, person tagging, draft→review→publish | 6 days |
| 10 | कार्यक्रम + गॅलरी | Event model, upcoming/past, auto-assembled gallery | 4 days |
| 11 | Poster generator | Client-side WhatsApp poster from any article | 4 days |
| 12 | SEO, performance, launch | Sitemap, schema, Lighthouse, DNS cutover, backups | 4 days |

Roughly 8 weeks solo at a steady pace. Phases 01 and 09 are where quality is decided — do not rush them.

---

## Reference docs

| File | What it holds |
|------|---------------|
| `docs/00-project-brief.md` | Product context, audience, non-negotiables, open questions |
| `docs/01-glossary.md` | Locked Marathi ↔ English ↔ code-name mapping |
| `docs/02-design-system.md` | Palette, fonts, type scale, Devanagari rules, spacing |
| `docs/03-data-model.md` | All models, fields, enums, relationships |
| `docs/04-routes.md` | Full URL map, both locales |
| `docs/05-content-checklist.md` | What the foundation must supply, and by when |
| `docs/06-infrastructure.md` | Railway, Cloudflare, R2, BigRock, email, costs |
| `assets-source/README.md` | Where to put photos, naming rules, size specs |

---

## Standing rules for every phase

These apply whether or not a given prompt repeats them.

- **Marathi is the default locale.** Not English with Marathi bolted on.
- **Never** apply `letter-spacing` or `text-transform: uppercase` to Devanagari text.
- **No `localStorage`/`sessionStorage`** anywhere. Server-side session or DB only.
- **No AI-generated photographs**, ever, including as placeholders in production. Use flat grey blocks with dimensions labelled until real photos arrive.
- **No seed data with fake people.** Use obviously-placeholder names (`नमुना नाव १`) so nothing fake can leak to production.
- **Every user-facing string** goes in a locale YAML file. No hardcoded text in views, in either language.
- **Commit at the end of every phase** with the phase number in the message.
- **Placeholder values** (address, phone, stats, registration number) live in `SiteSetting` or locale YAML — never hardcoded — because they are all still unconfirmed.

---

## Unresolved — confirm before Phase 05

These are still open and will cause rework if guessed:

1. **Location.** Earlier mockups placed the foundation in Ujjain, Madhya Pradesh. "उज्जैनकर" is a Marathi surname. Confirm the actual city and district before any address, dateline, or map goes in.
2. **Registration.** Trust or Society? Registration number and date as printed on documents.
3. **12A / 80G status.** Determines what the Donate and Transparency pages can claim.
4. **कार्यक्षेत्रे list.** Currently assuming शिक्षण, आरोग्य, पर्यावरण, अन्न वितरण, महिला सक्षमीकरण.
5. **Real impact numbers.** The mockup figures are invented and must not ship.
