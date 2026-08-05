# Design System

The single most differentiating part of this project. Read fully before Phase 01.

---

## Direction

**Editorial and documentary**, not corporate. The peer set is WordPress templates with blue gradients, autoplaying carousels, and stock photos of cupped hands. The bar is low, so differentiation is cheap — it comes almost entirely from typography, restraint, and real photography.

Reference feel: a well-set Marathi literary magazine or a serious regional newspaper's culture section. Not a startup landing page.

---

## Palette

Deep maroon. Chosen over the saffron-and-green alternative because that combination reads as tricolour/political — the last association a registered public charity wants. Maroon reads institutional and warm, and is uncommon in this category.

```css
--brand-900: #3F0F17;  /* darkest — footer ground */
--brand-800: #55151F;
--brand-700: #6E1B26;  /* PRIMARY — headers, buttons, links */
--brand-600: #8A2430;
--brand-500: #A63946;  /* hover */
--brand-100: #F4E4E4;  /* tinted panels */

--accent-600: #B4622A;  /* warm ochre — sparingly, ONE use per screen */
--accent-100: #F7EADF;

--paper:     #FAF7F2;  /* page background — warm off-white, NOT #FFF */
--surface:   #FFFFFF;  /* cards */
--ink:       #1A1614;  /* body text — warm near-black, NOT #000 */
--ink-muted: #6B615C;
--line:      #E5DDD4;

--success: #2E6B4F;
--warn:    #A6721E;
--danger:  #9B2C2C;
```

### Rules

- **One accent per screen.** The ochre is for the single most important call to action on the page. Not for five different icons.
- **No gradients.** Anywhere.
- **No multicoloured icon sets.** The mockup's green/orange/red/green/blue focus-area icons are the classic template tell. Use one colour at varying opacity, or monochrome line icons at a single weight.
- **Never pure white or pure black.** `--paper` and `--ink`.

---

## Typography

### Fonts — self-hosted, subsetted woff2, preloaded

| Role | Devanagari | Latin |
|---|---|---|
| Display / headlines | **Tiro Devanagari Marathi** | Source Serif 4 |
| Body | **Mukta** (400/600/700) | Inter |
| Numerals in stats | Mukta 700 | Inter 700 |

Do not load from Google Fonts CDN at runtime. Download, subset to the ranges actually used, self-host, and `<link rel="preload">` the two body weights. This matters for the 4G-mobile audience.

Tiro Devanagari Marathi is specifically the Marathi-language cut — it handles the ल and श forms Marathi expects, which differ from Hindi convention. Use that cut, not the generic Tiro Devanagari Sanskrit.

### Devanagari metrics — non-negotiable

Devanagari carries matras above and below the shirorekha, and has a smaller apparent x-height than Latin at the same point size. Latin defaults look cramped and small.

```css
[lang="mr"], [lang="hi"] {
  font-size: 1.0625rem;   /* 17px base — ~1.1× the Latin base */
  line-height: 1.8;       /* body. Never below 1.7 */
}
[lang="mr"] h1, [lang="mr"] h2, [lang="mr"] h3 {
  line-height: 1.4;       /* headings — tighter, but never below 1.3 */
}
[lang="en"] {
  font-size: 1rem;        /* 16px */
  line-height: 1.6;
}
```

**Forbidden on Devanagari, always:**

```css
letter-spacing: anything;   /* breaks conjuncts — क्ष ज्ञ त्र */
text-transform: uppercase;  /* the concept does not exist in the script */
font-stretch: condensed;
```

Set these as a lint rule if possible. They are the most common Devanagari mistakes and they are immediately visible to a native reader.

### Type scale

Two scales, switched by locale. Devanagari runs one step larger throughout.

| Token | Marathi | English |
|---|---|---|
| `display` | 3.25rem / 1.25 | 3rem / 1.15 |
| `h1` | 2.5rem / 1.35 | 2.25rem / 1.2 |
| `h2` | 1.875rem / 1.4 | 1.75rem / 1.25 |
| `h3` | 1.375rem / 1.5 | 1.25rem / 1.35 |
| `body-lg` | 1.1875rem / 1.85 | 1.125rem / 1.65 |
| `body` | 1.0625rem / 1.8 | 1rem / 1.6 |
| `small` | 0.9375rem / 1.7 | 0.875rem / 1.5 |

Mobile: scale `display` and `h1` down by ~30%, leave body sizes alone. Do not shrink Devanagari body text below 16px on any viewport.

### Measure

Marathi body copy: **60–70 characters** per line. Devanagari words run longer than Latin, so a 75ch measure that feels right in English feels sprawling in Marathi.

---

## Layout

- Container max width `1200px`, gutters `24px` mobile / `48px` desktop.
- Spacing scale: `4 8 12 16 24 32 48 64 96 128`. Nothing off-scale.
- Section vertical rhythm: `96px` desktop, `64px` mobile.
- Cards: `border-radius: 8px`, `1px solid var(--line)`, no shadow at rest, subtle shadow on hover only. Not `rounded-2xl` with a heavy drop shadow — that reads as template.
- News index uses an **asymmetric editorial grid** (one lead item spanning two columns, then a denser list), not a uniform 3-column card wall.

---

## Photography

**The single biggest gap between a good mockup and a great site.** Synthetic or stock photography is visible instantly and undermines a charity's credibility more than most sectors.

- Real photographs of real people at real programmes.
- Names in captions. `डावीकडून: ...` press-caption convention.
- One day of a local photographer will do more for perceived quality than any amount of code.
- **Until real photos exist:** flat `--line` coloured blocks with the intended dimensions written on them. Never AI-generated placeholders — they have a way of surviving into production.

---

## Motion

- Turbo 8 page morphing plus CSS view transitions for navigation.
- Hover and focus transitions at `150ms ease-out`.
- Nothing else. No scroll-triggered fade-ins, no parallax, no counters that animate on scroll, no carousels.
- Honour `prefers-reduced-motion` on everything that remains.

---

## Components — Phase 01 deliverables

Build these as partials with every state (default, hover, focus-visible, disabled, loading, error):

`btn-primary` · `btn-secondary` · `btn-ghost` · `card` · `card-article` · `card-event` ·
`page-header` (coloured band + breadcrumb) · `breadcrumb` · `tag` · `stat` ·
`form-field` (label, input, hint, error) · `select` · `textarea` · `checkbox` ·
`pagination` · `empty-state` · `flash` · `photo-figure` (image + caption + credit) ·
`share-whatsapp` · `lang-switch`

Render each in both locales side by side on a `/styleguide` page (dev environment only). Devanagari and Latin at the same nominal size look wrong together — the styleguide is how you catch that early.

---

## Accessibility floor

- Contrast ≥ 4.5:1 body, ≥ 3:1 large text. `--brand-700` on `--paper` passes; verify every pairing.
- Visible `:focus-visible` ring, `2px solid var(--accent-600)`, `2px` offset. Never `outline: none`.
- Tap targets ≥ 44×44px.
- `lang` attribute set correctly per element — mixed-script pages need it or screen readers mispronounce.
- Full keyboard navigation including the language switcher and mobile menu.
