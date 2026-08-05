# Phase 07 — Admin & Authentication

**First: read `docs/00-project-brief.md` (roles section) and `docs/03-data-model.md`.**

---

## Goal

Staff-only login, three roles, and an admin panel a non-technical Marathi-speaking media person will actually use on a phone.

## Tasks

1. **Authentication** — Rails 8's built-in auth generator. `has_secure_password`, session-based.
   **There is no public registration.** No sign-up route exists. Accounts are created by the admin. Make sure the generator's registration routes are removed, not just unlinked.

2. **Roles** — enum on `User`: `admin`, `editor`, `reporter`. Displayed as प्रशासक / संपादक / वार्ताहर. A simple enum, not a permissions gem — the matrix is small enough to express in three `can_*?` methods.

   | | reporter | editor | admin |
   |---|---|---|---|
   | Create article | ✓ | ✓ | ✓ |
   | Edit own draft | ✓ | ✓ | ✓ |
   | Edit others' | — | ✓ | ✓ |
   | Publish / unpublish | — | ✓ | ✓ |
   | Delete | — | — | ✓ |
   | Users & settings | — | — | ✓ |

3. **Avo 3** — resources for every model. Do not hand-roll a dozen CRUD screens; that is three weeks spent on something already solved.
   - Admin UI labels in **Marathi**, defaulting to `mr`
   - Custom dashboard: pending review count, drafts, recent published, unread messages, new volunteers
   - Scope resources by role using Avo's authorisation hooks

4. **Password reset** by email. Marathi email template.

5. **Session security** — `rack-attack` on login (5 attempts / 20 minutes per IP), secure/httponly/same-site cookies, session timeout, `last_seen_at` tracking.

6. **Audit trail** — who published what and when. Even a simple `published_by_id` plus timestamps is enough. For a foundation's public statements, knowing who approved an announcement matters.

## Watch for

- **Phone-first admin.** Assume posts get written on a phone at an event venue. Test the article form at 360px with a real thumb, not a mouse-driven emulator.
- Avoid English jargon in the Marathi admin. "Slug", "meta description", "publish status" mean nothing to the intended user — use plain Marathi labels with short hint text.
- Do not let Avo's default English strings leak through. Audit every screen in `mr`.

## Definition of done

- [ ] Login works; **no public registration route exists**
- [ ] All three roles enforced server-side, verified by tests attempting privilege escalation
- [ ] Avo dashboard in Marathi with the five counts
- [ ] Password reset delivers and works
- [ ] Login rate-limited
- [ ] Article form usable one-handed on a 360px phone
- [ ] Committed: `phase-07: admin and auth`
