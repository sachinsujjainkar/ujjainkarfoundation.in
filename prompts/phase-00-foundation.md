# Phase 00 — Foundation & Setup

**First: read `docs/00-project-brief.md`, `docs/01-glossary.md`, and `docs/06-infrastructure.md`. Do not skip.**

---

## Goal

A Rails 8 app that boots locally, passes CI, and deploys to Railway. No design, no content, no models beyond what Rails generates. Just a solid floor.

## Tasks

1. **Generate the app**
   ```
   rails new ujjainkarfoundation -d postgresql -c tailwind -j importmap
   ```
   Ruby 3.3+, Rails 8. Keep Solid Queue, Solid Cache, and Solid Cable — no Redis anywhere in this project.

2. **Gemfile**
   - `mobility` — translated model content
   - `avo` (3.x) — admin
   - `image_processing` — libvips, for Active Storage variants
   - `aws-sdk-s3` — for Cloudflare R2 via the S3 adapter
   - `rack-attack`
   - `sentry-ruby`, `sentry-rails`
   - `friendly_id` *(only if you want slug history; plain slug columns are fine and simpler — pick one and note the choice in the README)*
   - dev/test: `rubocop-rails-omakase`, `brakeman`, `dotenv-rails`, `faker`

3. **Database**
   - PostgreSQL 16 locally
   - Enable `pg_trgm` in a migration. **Postgres full-text dictionaries do not support Marathi** — trigram search is the approach for Devanagari, and setting it up now avoids a retrofit in Phase 09.

4. **Config**
   - `config.i18n.available_locales = [:mr, :en]`
   - `config.i18n.default_locale = :mr` — Marathi is the default, not English
   - `config.time_zone = "Mumbai"`
   - Force SSL in production

5. **CI** — GitHub Actions on push and PR: `bundle exec rubocop`, `bundle exec brakeman`, `bin/rails test`. Failing CI blocks merge.

6. **Railway**
   - New **project** in the existing account. Not a new account, not a service inside the DealKhata project — see `docs/06-infrastructure.md` for why.
   - Services: `web` + `postgres`
   - Env vars per the infrastructure doc
   - `/up` health check wired to Railway
   - Confirm a deploy succeeds and the health check is green

7. **README** — setup steps, env vars, how to run tests, deploy process, link to this pack.

## Watch for

- `sh` does not support brace expansion; use explicit paths in any setup scripts.
- Set `default_locale = :mr` **now**. Changing it later means auditing every route helper and fallback.
- Do not add Redis. Rails 8's Solid adapters cover queue, cache, and cable on Postgres.

## Definition of done

- [ ] `bin/rails s` boots, root returns 200
- [ ] `bin/rails test` green
- [ ] RuboCop and Brakeman clean
- [ ] `pg_trgm` extension present
- [ ] `I18n.default_locale == :mr`
- [ ] Deployed to Railway, `/up` green, custom domain not yet pointed
- [ ] Committed: `phase-00: foundation and setup`
