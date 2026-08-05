# Phase 12 — SEO, Performance & Launch

**First: read `docs/04-routes.md` (SEO section) and `docs/06-infrastructure.md`.**

---

## Goal

Ship it, and make sure it can be found and restored.

## Part A — SEO

1. **Sitemap** at `/sitemap.xml` — both locales, hreflang alternates on every entry, regenerated on publish. Submit to Google Search Console for both `mr` and `en`.

2. **Structured data**
   - `NGO`/`Organization` on the homepage, with registration number once confirmed
   - `NewsArticle` on articles
   - `Event` on event pages
   - `BreadcrumbList` throughout
   Validate everything in Google's Rich Results Test.

3. **Meta** — unique title and description per page, both locales. OG and Twitter cards. Article OG image falls back to the site default.

4. **`robots.txt`** — allow all public, disallow `/admin`, point at the sitemap.

5. **Google Business Profile** in Marathi, once the location is confirmed. For a local foundation this drives more discovery than organic search does.

## Part B — Performance

Targets, mobile, on the article and home pages:
- Lighthouse Performance ≥ 90, Accessibility ≥ 95, SEO 100
- LCP < 2.5s, CLS < 0.1, INP < 200ms

- Preload the hero image and the two body font weights
- Cloudflare caching rules: aggressive on `/assets` and R2, bypass on `/admin`
- Fragment-cache article and event cards
- Audit and cut unused JS; the importmap should be small
- Test on a throttled 4G profile, not on desktop broadband

## Part C — Accessibility

- axe DevTools clean on every page template
- Full keyboard traversal including mobile menu, language switcher, lightbox, poster editor
- Screen reader pass with correct per-element `lang`
- Contrast verified across the whole palette
- `prefers-reduced-motion` honoured

## Part D — Launch

1. **DNS cutover** — BigRock nameservers → Cloudflare; `A`/`CNAME` → Railway, proxied; `MX` → Square Brokers, **unproxied**; SPF, DKIM, DMARC. Details in the infrastructure doc.
2. **SSL** verified, HSTS on.
3. **Backups** — weekly `pg_dump` to R2, 90-day retention. **Restore one into a scratch database before launch.** An untested backup is not a backup.
4. **Monitoring** — Sentry live, uptime check on `/up`, Railway usage alert so the bill cannot surprise anyone.
5. **Analytics** — Umami or Plausible, no cookie banner needed.
6. **Content load** — seed the 5–10 real Marathi articles so the site does not launch empty.
7. **Handover** — a short Marathi guide for the media person: how to log in, write an article, add photos, submit for review, generate a poster. Screenshots, not prose. Do a live walkthrough with them.

## Pre-launch checklist

- [ ] No placeholder or invented content anywhere in production
- [ ] Location, registration number, and contact details confirmed and correct
- [ ] 80G claims present **only** if the certificate is in hand
- [ ] No AI-generated imagery
- [ ] Every form tested end to end, emails arriving
- [ ] Backup restore rehearsed
- [ ] Search Console verified, sitemap submitted
- [ ] Handover session completed and the weekly poster identified by name
- [ ] Committed and tagged `v1.0.0`

## After launch — the thing that actually matters

The build is the easy part. The failure mode for NGO sites is that nobody posts after month two.

Schedule a check-in at **week 2, week 6, and month 3**. If posting has stalled, that is a workflow problem to solve with the foundation, not a feature to build. Fixing it is worth more than anything in Phase 2's roadmap.
