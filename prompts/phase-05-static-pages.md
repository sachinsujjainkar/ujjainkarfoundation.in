# Phase 05 — Static Pages

**First: read `docs/00-project-brief.md`, `docs/04-routes.md`, and `docs/05-content-checklist.md`.**

**Confirmed location and registration** — use these throughout this phase:
- मुक्ताईनगर, ता. मुक्ताईनगर, जि. जळगाव, महाराष्ट्र – 425306
- Public Trust reg. एफ-११४७३ (जळगांव), registered दि. १२/०५/२०१०
- ISO 9001:2015 certified

---

## Goal

Every page that is not driven by the newsroom.

## Pages

1. **आमच्याविषयी** — identity, history, ध्येय, दृष्टी, values, founder section with portrait and 150–200 words. All copy from locale YAML so it is editable without touching views.
   Founder content already exists in `docs/content/founder/biography.md` — use it rather than writing fresh copy. The foundation's lineage belongs in the history section: अंकुर साहित्य संघ, परम पूज्य महर्षी वाल्मिकी बहुउद्देशीय मंडळ → कवी राम कदम फाउंडेशन (2009) → शिवचरण उज्जैनकर फाउंडेशन (2016).

2. **कार्यकारणी** — office bearers, built on the new `Committee` and `Membership` models (schema in `docs/03-data-model.md`), not a flag on `Person`. Three concurrent committees, roughly 60 people total, displayed as an accordion with one section per committee. Each member shows honorific, name, role title, and city — note that `role_title` lives on the `Membership`, not on `Person`. **Never render `phone` or `email`** — admin-only fields.

3. **संपर्क** — address, phones, email, hours, map embed, and an inquiry form (`ContactMessage`). hCaptcha and `rack-attack` on submit. All contact values from `SiteSetting`.

4. **स्वयंसेवक** — registration form (`Volunteer`). Fields: नाव, मोबाइल, ईमेल, तालुका, आवडीचे क्षेत्र, संदेश. Marathi validation messages. Confirmation email via Brevo/Resend. Success state on-page, not a redirect to a bare thank-you.

5. **देणगी** — information only in Phase 1. Bank details, UPI ID, UPI QR. 80G status **only if confirmed**. What donations fund. No payment gateway yet.

6. **पारदर्शकता** — the page donors and CSR desks actually read. Registration type and number, 12A/80G certificates as downloadable PDFs, annual reports, office bearers link, contact for queries. This page is disproportionately valuable relative to its effort.
   **Watch the registration date:** the ११५४२ number and ८/१/२०१० date shown on the logo seal are a separate certificate (likely ISO), not the trust registration date — do not use them here. The trust registration is एफ-११४७३ (जळगांव), दि. १२/०५/२०१०.

7. **Privacy policy** and **terms** — needed for the footer links to be honest.

## Tasks

- `Person`, `Committee`, `Membership`, `Volunteer`, `ContactMessage`, `SiteSetting` models and migrations. Seed all three committees from `docs/content/organisation/committees.md`.
- `SiteSetting` as a singleton with sensible placeholder defaults and a seed task.
- Server-side validation on both forms, with errors rendered inline in the correct locale.
- Long-form copy in locale YAML, not hardcoded in ERB.

## Watch for

- Marathi validation messages must read naturally, not like machine translations of English error strings. `कृपया आपले नाव लिहा`, not `नाव आवश्यक आहे फील्ड`.
- Do not claim 80G eligibility anywhere unless the certificate is in hand. Gate that copy behind `SiteSetting#has_80g`.
- If foreign donations are ever a possibility, FCRA registration and a designated account are required — worth flagging to the foundation now, even though it is out of scope for this build. Not legal advice; their CA should confirm.

## Definition of done

- [ ] All seven pages, both locales
- [ ] Contact and volunteer forms submit, validate, and email
- [ ] Captcha and rate limiting live on both
- [ ] Every address/phone/email reads from `SiteSetting`
- [ ] Person phone/email never appear in any public response
- [ ] Committed: `phase-05: static pages`
