# Phase 03 — Layout Shell

**First: read `docs/02-design-system.md` and `docs/01-glossary.md`.**

---

## Goal

The frame every page sits in: header, navigation, language switcher, footer, breadcrumbs, page header band, flash messages, error pages.

## Tasks

1. **Header**
   - Logo (placeholder SVG until the real vector arrives) + wordmark उज्जैनकर फाउंडेशन + tagline
   - Nav: मुख्यपृष्ठ · आमच्याविषयी · कार्यक्षेत्रे · कार्यक्रम · बातम्या · गॅलरी · संपर्क
   - Language switcher (मराठी / English)
   - One CTA: देणगी द्या
   - Sticky on scroll with a subtle border, no shadow, no shrink animation

2. **Mobile navigation** — full-screen overlay, not a cramped dropdown. Large tap targets, focus trapped, closes on Escape and on backdrop click, and returns focus to the trigger. Stimulus controller, no external library.

3. **Page header band** — coloured band carrying page title + breadcrumb, as in the reference mockups. This pattern works; keep it. Variant with a background image for section landing pages.

4. **Breadcrumbs** — `मुख्यपृष्ठ / बातम्या / [शीर्षक]`, with `BreadcrumbList` structured data.

5. **Footer**
   - Column 1: logo, one-line description, social icons
   - Column 2: महत्त्वाचे दुवे
   - Column 3: सहभाग घ्या
   - Column 4: संपर्क माहिती — **all values from `SiteSetting`, none hardcoded**
   - Bottom bar: dynamic copyright year, registration number, privacy, terms

6. **Error pages** — 404 and 500, fully bilingual, styled, with a route back. Marathi copy: `पृष्ठ सापडले नाही`.

7. **Flash messages** — Turbo-friendly, dismissible, `aria-live` announced.

8. **Turbo 8 page morphing** + CSS view transitions for navigation. Honour `prefers-reduced-motion`.

9. **SEO scaffolding in the layout** — title template, meta description, canonical, OG and Twitter tags, hreflang, all driven by `content_for` so pages can override cleanly.

## Watch for

- Devanagari nav items are wider than their English equivalents. Test the header at 360px width with the Marathi labels **before** deciding the breakpoint where the mobile menu kicks in — deciding it against English labels will produce a broken Marathi header.
- No hardcoded contact details anywhere. Location is still unconfirmed (see `docs/00-project-brief.md`) so any address baked into a template will be wrong and will be hard to find later.

## Definition of done

- [ ] Header and footer render in both locales, correct at 360px through 1920px
- [ ] Mobile menu: focus trapped, Escape closes, focus returns
- [ ] Breadcrumbs with structured data
- [ ] 404 and 500 styled in both languages
- [ ] Every footer value reads from `SiteSetting`
- [ ] Full keyboard traversal of header, nav, switcher, footer
- [ ] Committed: `phase-03: layout shell`
