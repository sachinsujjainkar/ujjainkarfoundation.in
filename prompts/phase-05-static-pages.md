# Phase 05 — Static Pages

**First: read `docs/00-project-brief.md`, `docs/04-routes.md`, and `docs/05-content-checklist.md`.**

⚠️ **Blocking check before you start:** the city and district of operation must be confirmed. Earlier mockups placed the foundation in Ujjain, Madhya Pradesh, but "उज्जैनकर" is a Marathi surname and the foundation may be in Maharashtra. Every address, dateline, and map on this site depends on the answer. If it is still unconfirmed, build with `SiteSetting` placeholders and flag it loudly in the commit message.

---

## Goal

Every page that is not driven by the newsroom.

## Pages

1. **आमच्याविषयी** — identity, history, ध्येय, दृष्टी, values, founder section with portrait and 150–200 words. All copy from locale YAML so it is editable without touching views.

2. **पदाधिकारी** — office bearers grid. Uses the `Person` model, so create it here (schema in `docs/03-data-model.md`) with `committee_member: true`. Portrait, name, role title, term. **Never render `phone` or `email`** — admin-only fields.

3. **संपर्क** — address, phones, email, hours, map embed, and an inquiry form (`ContactMessage`). hCaptcha and `rack-attack` on submit. All contact values from `SiteSetting`.

4. **स्वयंसेवक** — registration form (`Volunteer`). Fields: नाव, मोबाइल, ईमेल, तालुका, आवडीचे क्षेत्र, संदेश. Marathi validation messages. Confirmation email via Brevo/Resend. Success state on-page, not a redirect to a bare thank-you.

5. **देणगी** — information only in Phase 1. Bank details, UPI ID, UPI QR. 80G status **only if confirmed**. What donations fund. No payment gateway yet.

6. **पारदर्शकता** — the page donors and CSR desks actually read. Registration type and number, 12A/80G certificates as downloadable PDFs, annual reports, office bearers link, contact for queries. This page is disproportionately valuable relative to its effort.

7. **Privacy policy** and **terms** — needed for the footer links to be honest.

## Tasks

- `Person`, `Volunteer`, `ContactMessage`, `SiteSetting` models and migrations.
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
