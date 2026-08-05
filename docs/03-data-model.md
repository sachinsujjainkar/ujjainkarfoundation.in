# Data Model

Translated fields use Mobility (`:table` backend — a `_translations` table per model). Everything else is a plain column.

---

## User — staff only

No public registration. Accounts created by admin.

```
name              string, required
email             string, required, unique, downcased
password_digest   string  (has_secure_password — Rails 8 auth generator)
role              enum: admin | editor | reporter
active            boolean, default true
last_seen_at      datetime
```

`Person` is separate from `User` — office bearers are not necessarily staff, and most people mentioned in articles never log in.

---

## Activity — कार्यक्षेत्र

```
slug          string, unique, indexed
icon_key      string          # references an internal monochrome icon set
position      integer         # manual ordering
published     boolean, default false
```
Translated: `name`, `tagline`, `description` (rich text), `seo_title`, `meta_description`

`has_many :articles` · `has_many :events` · `has_one_attached :hero_image`

---

## Article — बातमी

The centrepiece. Shaped to Marathi press writing, not to a generic blog post.

```
slug                        string, unique, indexed   # frozen after create
article_type                enum (see glossary)
status                      enum: draft|submitted|published|archived
dateline_place              string        # "पुणे" — renders as "पुणे, दि. ५ ऑगस्ट"
published_at                datetime, indexed
author_id                   → User
published_by_id             → User, nullable
activity_id                 → Activity, nullable
event_id                    → Event, nullable
featured                    boolean, default false
needs_english_translation   boolean, default false
view_count                  integer, default 0
```
Translated: `headline`, `subheadline` (उपशीर्षक), `body` (rich text), `seo_title`, `meta_description`

`has_many :article_photos` · `has_many :mentions` · `has_many :people, through: :mentions` ·
`has_one_attached :featured_image` · `has_one_attached :notice_pdf`

**Marathi is required. English is optional** — validate presence of `headline_mr` and `body_mr` only.

`subheadline` matters: Marathi newspapers use a kicker line under the headline constantly, and its absence is why generic CMS output reads as foreign.

`notice_pdf` is for the formal circular or notice that often accompanies an appointment or award announcement.

---

## ArticlePhoto

```
article_id   → Article
position     integer
credit       string
```
Translated: `caption`

`has_one_attached :image`

Caption is a **translated content field**, not alt text — press photos need `डावीकडून: ...` style captions visible on the page. Alt text is separate and derived.

---

## Person — व्यक्ती

Does double duty: office bearers **and** anyone named in an article.

```
slug              string, unique, indexed
committee_member  boolean, default false
position_order    integer
term_start        date
term_end          date, nullable
phone             string, nullable        # never public
email             string, nullable        # never public
```
Translated: `name`, `role_title` (अध्यक्ष, सचिव…), `bio`

`has_one_attached :photo` · `has_many :mentions` · `has_many :articles, through: :mentions`

**This is the quiet differentiator.** Tagging people in articles gives you an automatic page per person showing everything they have been mentioned in — office bearers, awardees, chief guests. No peer NGO site does this, and it is nearly free once the join table exists.

Privacy: `phone` and `email` are admin-only. Never render them in a public view, never include them in JSON, never put them in structured data.

---

## Mention — join

```
article_id  → Article
person_id   → Person
```
Unique index on `[article_id, person_id]`.

---

## Event — कार्यक्रम

```
slug          string, unique, indexed
starts_at     datetime, indexed
ends_at       datetime, nullable
venue_name    string
venue_address text
activity_id   → Activity, nullable
published     boolean, default false
youtube_id    string, nullable
```
Translated: `title`, `description`, `venue_note`

`has_many :event_photos` · `has_many :articles` · `has_one_attached :hero_image`

Upcoming vs past is derived from `starts_at`, not stored. Registration is Phase 2 — not in this build.

---

## EventPhoto

Same shape as `ArticlePhoto`, belonging to `Event`.

---

## Volunteer — स्वयंसेवक

```
name, phone, email, taluka   strings
interest_area_id             → Activity, nullable
message                      text
status                       enum: new|contacted|active|inactive
created_at
```

Form submission only. Not an account, no login.

---

## ContactMessage

```
name, email, subject   strings
message                text
read                   boolean, default false
created_at
```

---

## SiteSetting — singleton

Everything still unconfirmed lives here so it can be corrected without a deploy.

```
registration_number, registration_type, registration_date
address_line1, address_line2, city, district, state, pincode
phone_primary, phone_secondary, email_public
map_embed_url
facebook_url, instagram_url, youtube_url, twitter_url
stat_1_value, stat_1_label_mr, stat_1_label_en    (× 3)
donation_upi_id, donation_bank_details
has_12a, has_80g            booleans
```

Three stats, not five. Five metrics in one row with icon + number + label + sub-label is doing too much; three set large and unadorned reads as confident.

---

## Gallery — deliberately no model

The gallery page assembles itself from existing `ArticlePhoto` and `EventPhoto` records, grouped by कार्यक्षेत्र and year. One upload point, two display surfaces, nothing maintained twice.

Add a standalone `Album` model **only** if historical photo archives predating the site turn up. Confirm before building it.
