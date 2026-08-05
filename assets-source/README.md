# assets-source

**Master files only.** Nothing here is served by the application.

Two different things live in the project and must not be confused:

| | Where | How it gets there |
|---|---|---|
| **Brand assets** — logo, favicon, default OG image, icons | committed to the repo, `app/assets/images/` | copied from here, optimised |
| **Content media** — news photos, event photos, portraits | Cloudflare R2 via Active Storage | uploaded through the admin panel |

This folder is the **staging area and archive** for originals before either path. Keep full-resolution masters here; the app never reads from it.

---

## Tree

```
brand/
  logo/            SVG master + PNG exports (transparent, 1x/2x/3x)
  favicon/         16, 32, 180 (apple-touch), 512 (maskable)
  og-image/        1200×630 default social card
  letterhead/      print letterhead, for reference
banners/
  home-hero/       2400px+ wide, horizontal
  page-headers/    one per section
  cta/             donate/volunteer band backgrounds
committee/
  current/         office bearers now
  founders/        founder and historical figures
  archive/         past committees, by year
activities/
  shikshan/ aarogya/ paryavaran/ anna-vitaran/ mahila-sakshamikaran/
news/
  2026/  archive/
events/
  2026/  archive/
documents/
  certificates/    12A, 80G, registration
  annual-reports/
  policies/
  press-clippings/ scans of newspaper coverage — good Transparency content
poster-templates/
  backgrounds/ festival/ logo-overlay/
icons/             monochrome line icons, single weight, SVG
_originals/        untouched camera files before any editing
_rejected/         kept deliberately, so nobody re-crops a photo already ruled out
```

---

## Naming

Lowercase, hyphens, no spaces, no Devanagari in filenames — Devanagari filenames break on some upload paths and are miserable to work with on the command line.

```
YYYY-MM-DD-short-description-NN.jpg

2026-05-12-raktadan-shibir-01.jpg
2026-05-12-raktadan-shibir-02.jpg
committee/current/adhyaksha-ujjainkar-ramesh.jpg
brand/logo/ujjainkar-foundation-logo-primary.svg
```

Marathi captions live in the CMS, attached to the photo record. Not in the filename.

---

## Specs

| Use | Min width | Ratio | Target after processing |
|---|---|---|---|
| Home hero | 2400px | 16:9 or 21:9 | < 250KB |
| Article featured | 1600px | 3:2 | < 150KB |
| Article inline | 1600px | any | < 150KB |
| Committee portrait | 800px | 1:1 | < 80KB |
| Activity hero | 1600px | 3:2 | < 150KB |
| OG card | 1200×630 | fixed | < 200KB |

Upload the **full-resolution original** to the admin panel and let Active Storage generate variants. Do not pre-shrink — you cannot get detail back, and the variant pipeline handles AVIF/WebP better than a manual export will.

---

## Photo rules

- **Real photographs only.** No AI-generated or stock imagery, at any stage. It is visible instantly and it damages a charity's credibility more than most sectors.
- **Written consent required before any identifiable child's face is published.** Keep the consent record with the photo. This is not negotiable, and a blurred or wide shot is an acceptable substitute when consent is not available.
- Faces in focus, horizon straight, shot in landscape unless there is a reason not to.
- Caption every photo in Marathi with names where people are identifiable. `डावीकडून: ...`
- Photographer credit where owed.
- Never upload a screenshot of a photo, or a WhatsApp-compressed copy. Get the original from the photographer's phone.
