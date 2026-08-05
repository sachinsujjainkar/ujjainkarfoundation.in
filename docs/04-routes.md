# Routes

`mr` is the default locale. Both locales are always explicit in the path — no unprefixed routes — so that caching, hreflang, and sharing are unambiguous.

`/` redirects to `/mr` (or `/en` if `Accept-Language` clearly prefers English and no cookie is set).

---

## Public — Marathi

```
/mr                                     मुख्यपृष्ठ
/mr/aamchyavishayi                      आमच्याविषयी
/mr/aamchyavishayi/padadhikari          पदाधिकारी (committee)
/mr/karyakshetre                        कार्यक्षेत्रे index
/mr/karyakshetre/:slug                  e.g. /shikshan
/mr/batmya                              बातम्या index
/mr/batmya/prakar/:type                 filtered by article type
/mr/batmya/:id-:slug                    article detail
/mr/karyakram                           कार्यक्रम (upcoming + past)
/mr/karyakram/:slug
/mr/vyakti/:slug                        person page — all mentions
/mr/dalan                               गॅलरी
/mr/dalan/:year
/mr/swayamsevak                         volunteer form
/mr/dengi                               देणगी
/mr/pardarshakta                        पारदर्शकता
/mr/sampark                             संपर्क
/mr/shodha?q=                           search
```

## Public — English

Same tree, English stems:

```
/en  /en/about  /en/about/committee  /en/activities  /en/activities/:slug
/en/news  /en/news/type/:type  /en/news/:id-:slug
/en/events  /en/events/:slug  /en/people/:slug
/en/gallery  /en/gallery/:year  /en/volunteer  /en/donate
/en/transparency  /en/contact  /en/search?q=
```

Article and person IDs are shared across locales — `/mr/batmya/1042-...` and `/en/news/1042-...` are the same record. The language switcher maps between them by ID, never by dumping the user on the homepage.

---

## Admin — `/admin`, not locale-prefixed

Interface language follows the logged-in user's preference; Marathi is the default.

```
/admin                    dashboard
/admin/articles           list, filter by status/author/type
/admin/articles/new
/admin/articles/:id/edit
/admin/events
/admin/activities
/admin/people
/admin/volunteers
/admin/messages
/admin/users              admin only
/admin/settings           admin only
```

Avo 3 provides most of this. Custom work is limited to the article editor and the review queue.

---

## Utility

```
/sitemap.xml              both locales, hreflang alternates
/robots.txt
/feed.mr.xml  /feed.en.xml    RSS
/styleguide                    development environment only
/up                            Rails health check (Railway)
```

---

## SEO requirements per page

- `hreflang` pair on every page plus `x-default` pointing at `/mr`.
- Self-referencing canonical.
- `NewsArticle` structured data on articles — headline, datePublished, author, image, inLanguage. This is how the newsroom surfaces in news-style results, and it is worth doing properly rather than as an afterthought.
- `Event` structured data on event pages.
- `NGO` / `Organization` structured data on the homepage, including registration number once confirmed.
- Open Graph and Twitter cards on every page. Article OG image falls back to the site default when no featured image exists.
