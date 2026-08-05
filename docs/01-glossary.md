# Glossary — locked

This mapping becomes model names, table names, routes, and admin labels. Changing it after Phase 08 is expensive. Treat as fixed.

---

## Core entities

| Marathi | English | Model | Route stem | Notes |
|---|---|---|---|---|
| कार्यक्षेत्रे | Focus areas | `Activity` | `/mr/karyakshetre` | Thematic: शिक्षण, आरोग्य… Not dated. |
| कार्यक्रम | Events | `Event` | `/mr/karyakram` | Dated, with venue. Upcoming and past. |
| बातम्या | News | `Article` | `/mr/batmya` | The newsroom. Everything dated and published. |
| व्यक्ती | People | `Person` | `/mr/vyakti` | Office bearers **and** anyone mentioned in an article. |
| छायाचित्र दालन | Gallery | *(no model)* | `/mr/dalan` | Auto-assembled from article and event photos. |
| स्वयंसेवक | Volunteer | `Volunteer` | `/mr/swayamsevak` | Signup form submissions. |
| देणगी | Donation | — | `/mr/dengi` | Information page in Phase 1. |
| संपर्क | Contact | `ContactMessage` | `/mr/sampark` | |
| पारदर्शकता | Transparency | *(static)* | `/mr/pardarshakta` | Certificates, registration, reports. |
| आमच्याविषयी | About | *(static)* | `/mr/aamchyavishayi` | |

### The distinction that matters

**कार्यक्षेत्र** is a standing area of work — शिक्षण. **कार्यक्रम** is a dated occurrence — a शिबिर held on 25 May. Earlier drafts of this project used उपक्रम loosely for both; that ambiguity is now resolved and उपक्रम is **not** used as an entity name anywhere.

---

## Article types (`Article#article_type` enum)

| Marathi | Enum value | Use for |
|---|---|---|
| बैठक वृत्त | `meeting` | Meeting reports, minutes summaries |
| पुरस्कार | `award` | Awards received or conferred |
| निवड व नियुक्ती | `appointment` | Nominations, elections, appointments |
| कार्यक्रम वृत्त | `event_report` | Coverage of an event that has happened |
| निवेदन | `statement` | Press releases, official statements |
| उपक्रम वृत्त | `initiative` | Ongoing initiative updates |

`उपक्रम` survives here only as a *type label* meaning "initiative update" — never as an entity.

---

## Workflow states (`Article#status` enum)

| Marathi | Enum | Meaning |
|---|---|---|
| मसुदा | `draft` | Being written. Author only. |
| पुनरावलोकनासाठी | `submitted` | Awaiting editor approval. |
| प्रकाशित | `published` | Live. |
| संग्रहित | `archived` | Withdrawn from listings, URL still resolves. |

---

## Roles (`User#role` enum)

| Marathi | Enum |
|---|---|
| प्रशासक | `admin` |
| संपादक | `editor` |
| वार्ताहर | `reporter` |

---

## UI strings — canonical Marathi

Use exactly these. Do not paraphrase; consistency across the site matters more than variety.

| Element | Marathi |
|---|---|
| Home | मुख्यपृष्ठ |
| Read more | अधिक वाचा |
| View all | सर्व पहा |
| Search | शोधा |
| Share | शेअर करा |
| Submit | पाठवा |
| Register | नोंदणी करा |
| Download | डाउनलोड करा |
| Date | दिनांक |
| Venue | स्थळ |
| Upcoming | आगामी |
| Past | झालेले |
| Photos | छायाचित्रे |
| Videos | चित्रफिती |
| Founder | संस्थापक |
| Our vision | आमची दृष्टी |
| Our mission | आमचे ध्येय |
| Office bearers | पदाधिकारी |
| Not found | पृष्ठ सापडले नाही |

### Corrections from earlier mockups

- **कार्यें → कार्ये.** कार्यें is not correct Marathi.
- **उपक्रम used for Events → कार्यक्रम.** See above.
- Copyright year must render dynamically, never hardcoded.

---

## Slug policy

URLs use **Latin transliteration**, not Devanagari. WhatsApp is the main distribution channel, and Devanagari URLs percent-encode into unreadable strings when copied and pasted.

```
/mr/batmya/1042-shikshan-purskar-vitaran
```

Numeric ID prefix guarantees uniqueness and survives headline edits. Devanagari stays in titles, body, headings, and meta tags — where it is indexed and where it helps.

Transliteration is generated once on create from the Marathi headline, then frozen. Editing a headline does not change the slug.
