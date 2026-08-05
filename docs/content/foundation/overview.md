<!--
Feeds: आमच्याविषयी page copy (locale YAML), general "what is this org" framing
used in meta descriptions and the transparency page intro.

Already confirmed, no need to repeat here (see docs/content/README.md and
prompts/phase-05-static-pages.md):
- मुक्ताईनगर, ता. मुक्ताईनगर, जि. जळगाव, महाराष्ट्र – 425306
- Public Trust reg. एफ-११४७३ (जळगांव), registered दि. १२/०५/२०१०
- ISO 9001:2015 certified

What's still needed:
- One paragraph, Marathi: what the foundation does, in plain language, as if
  explaining to someone who has never heard of it.
- Same, English (donor/CSR audience — can be a little more formal).
- Any tagline or motto the foundation already uses publicly.
-->

## Marathi

(paste here)

## English

(paste here)

## Tagline (draft, not wired into the header — see note)

Source: Sachin, 2026-08-05 ("होमपेज सामग्री" homepage content fill).

- मराठी: सेवा • साहित्य • समर्पण
- English: Service • Literature • Dedication

Explicitly flagged by the source document as a draft superseding an
earlier generic-NGO tagline (सेवा • संस्कार • समृद्धी), written for this
foundation's actual literary/cultural identity -- but also flagged as
possibly superseded by a tagline the foundation already has. Not wired
into the live header: there's no tagline slot in the current design
(`app/views/layouts/_brand_mark.html.erb` shows name only), and adding one
is a small design decision of its own, not just copy -- worth doing
deliberately once the tagline itself is actually confirmed, rather than
building UI around a draft.
