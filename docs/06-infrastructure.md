# Infrastructure

## Accounts

| Service | Decision |
|---|---|
| Domain | BigRock — ujjainkarfoundation.in (already purchased) |
| DNS / CDN / SSL | Cloudflare Free — Mumbai PoP, matters for the audience |
| App + DB | Railway — **new project inside the existing account** |
| Object storage | Cloudflare R2 |
| Email (mailboxes) | Existing Square Brokers shared hosting |
| Transactional email | Brevo or Resend |
| Video | YouTube channel |
| Errors | Sentry free tier |
| Analytics | Umami or Plausible |

---

## Railway — same account, new project

Not a second account. Railway bills a plan fee plus metered usage, and the Hobby plan's $5/month includes $5 of usage pooled across the whole account. A second account pays the floor twice for nothing.

A separate **project** (not a service inside the DealKhata project) gives isolated env vars, its own Postgres, its own domain, independent deploys, and a clean per-project usage breakdown. It can also be moved out later if the foundation ever takes over its own hosting.

**Realistic cost.** The original ₹430/month estimate assumed the $5 credit covers everything. It will not: a Rails web service plus managed Postgres both running continuously exceed it. Budget **$12–20/month (~₹1,000–1,700)**. Cloudflare in front reduces the egress component substantially, since most traffic is cached images and static pages.

Services: `web` and `postgres`. No Redis — Rails 8 Solid Queue/Cache/Cable use the database.

---

## The Square Brokers hosting

Paid through 2028, cannot run Rails — shared cPanel gives PHP, MySQL, and no long-running processes. Not wasted, though:

1. **Mailboxes.** `info@`, `media@`, `adhyaksha@` on the domain, already paid for. Google Workspace would be ~₹150/user/month. Configure SPF and DKIM carefully — government and donor correspondence goes through this.
2. **Holding page today.** A bilingual "लवकरच येत आहे" page with contact details, up this week, while the real site is built.
3. Later: static PDF archives, if you would rather not pay egress for annual reports.

---

## DNS layout

1. BigRock: point nameservers at Cloudflare.
2. Cloudflare: `A`/`CNAME` for apex and `www` → Railway. Proxy **on**.
3. `MX` → Square Brokers mail servers. Proxy **off** (MX records cannot be proxied).
4. `TXT` for SPF, DKIM, DMARC.

Web to Railway, email to existing hosting. Changing hosts later becomes a two-minute DNS edit instead of a nameserver propagation wait.

**Watch the renewal.** BigRock's `.in` renewal rates run well above market. Set a reminder ahead of the date and either negotiate or transfer.

---

## Media storage — Cloudflare R2

Chosen over S3 because **egress is the cost driver for a public photo-heavy site, not storage**. S3 charges roughly $0.09/GB outbound; R2 charges nothing. An article with two 800KB photos viewed 2,000 times is ~3GB of egress — trivial on R2, a recurring line item on S3. Over three years of weekly posting the gap compounds.

R2 is S3-API compatible, so Active Storage uses the standard `aws-sdk-s3` adapter with a custom endpoint. No extra gem.

```yml
# config/storage.yml
cloudflare:
  service: S3
  endpoint: https://<account_id>.r2.cloudflarestorage.com
  access_key_id: <%= ENV["R2_ACCESS_KEY_ID"] %>
  secret_access_key: <%= ENV["R2_SECRET_ACCESS_KEY"] %>
  region: auto
  bucket: ujjainkar-media
  force_path_style: true
```

If you would rather keep everything in one place operationally, a **separate bucket in the existing AWS account** is acceptable — never a shared bucket. Separate bucket means separate IAM keys, separate lifecycle rules, separate CORS, and a clean handover later.

### Variants

libvips via `image_processing`. Widths 400 / 800 / 1600, AVIF with WebP fallback, `loading="lazy"`, `decoding="async"`, explicit `width`/`height` to prevent layout shift.

### Video — YouTube only

Never serve video from own storage. One 100MB clip going semi-viral on WhatsApp costs more than a year of hosting. Upload to the foundation's YouTube channel, embed with a lightweight click-to-load facade so the player JS never loads unless clicked. Also a free second discovery surface.

---

## Environment variables

```
DATABASE_URL                  (Railway provides)
RAILS_MASTER_KEY
R2_ACCESS_KEY_ID / R2_SECRET_ACCESS_KEY / R2_BUCKET / R2_ENDPOINT
R2_PUBLIC_HOST
SMTP_ADDRESS / SMTP_USERNAME / SMTP_PASSWORD
SENTRY_DSN
HCAPTCHA_SITE_KEY / HCAPTCHA_SECRET
APP_HOST=ujjainkarfoundation.in
```

---

## Security baseline

- `rack-attack` on all public forms and the login endpoint.
- hCaptcha on volunteer and contact forms.
- Brakeman and RuboCop in CI, blocking merge.
- Strong parameters everywhere; `dependabot.yml` on.
- Content Security Policy allowing only self, R2 host, and YouTube.
- Force SSL, HSTS.

---

## Backups

Railway's Postgres backups are the floor, not the plan. Add a weekly `pg_dump` to R2 with 90-day retention, and **restore it into a scratch database once before launch**. An untested backup is not a backup.
