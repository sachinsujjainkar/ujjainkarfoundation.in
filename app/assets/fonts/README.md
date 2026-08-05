# Fonts

Self-hosted, subsetted woff2. Never load from the Google Fonts CDN at runtime — the audience is
on mid-range Android over 4G. See `docs/02-design-system.md` for the role each font plays.

| File | Family | Weight | Script coverage |
|---|---|---|---|
| `tiro-devanagari-marathi-regular.woff2` | Tiro Devanagari Marathi | 400 | Devanagari + Latin |
| `mukta-400.woff2` / `-600` / `-700` | Mukta | 400 / 600 / 700 | Devanagari + Latin |
| `source-serif-4-display-400.woff2` | Source Serif 4 | 400 (opsz pinned to 40, display cut) | Latin |
| `inter-400.woff2` / `-600` / `-700` | Inter | 400 / 600 / 700 (opsz pinned to 14, text cut) | Latin |

Rebuild with `script/build-fonts.sh` (needs `fonttools` + `brotli`, see that script's header).

## Decisions worth knowing

- **Subset ranges** are Devanagari core block + ZWJ/ZWNJ (needed for conjuncts like क्ष ज्ञ त्र)
  + Rupee sign, and Latin basic + Latin-1 + general punctuation + currency. This is broader than
  "exactly what's on the site today" because there's no real content yet — once articles exist,
  re-run with a tighter `--unicodes` list if file size becomes a problem.
- **Inter and Source Serif 4 ship as variable fonts upstream.** Both are pinned to static
  weight/optical-size instances before subsetting, because Avo/Tailwind's asset pipeline here
  serves plain woff2, not variable-font ranges. Source Serif 4 is pinned to `wght=400` (not a
  bolder weight) specifically because Tiro Devanagari Marathi only ships a Regular cut, and the
  design system uses one heading style across both scripts — a bolder Latin display weight next
  to a regular-weight Devanagari one would look visually uneven in mixed headings.
- **`--layout-features='*'` is kept during subsetting.** Dropping GSUB/GPOS tables breaks
  Devanagari conjunct shaping. Verify after any resubset with a script like:
  `python3 -c "from fontTools.ttLib import TTFont; print('GSUB' in TTFont('FILE.woff2'))"`
