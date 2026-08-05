# Path segments that are genuinely different translated words per locale
# (आमच्याविषयी -> aamchyavishayi vs about), not just a swapped :locale
# prefix -- see docs/04-routes.md. Drives both the routes in
# config/routes.rb and the `localized_path`/`localized_url` view helpers
# in ApplicationHelper.
#
# Controllers/actions here are the eventual real ones (matching
# docs/03-data-model.md's model names), so later phases fill in real
# actions/views rather than renaming anything.
module LocalizedPages
  SEGMENTS = {
    about:        { mr: "aamchyavishayi", en: "about" },
    # docs/04-routes.md originally nests this under /aamchyavishayi/padadhikari;
    # kept flat here instead, consistent with every other page in this table
    # (and renamed from पदाधिकारी to कार्यकारणी -- prompts/phase-05-static-pages.md).
    committee:    { mr: "karyakarani",    en: "committee" },
    activities:   { mr: "karyakshetre",   en: "activities" },
    articles:     { mr: "batmya",         en: "news" },
    events:       { mr: "karyakram",      en: "events" },
    gallery:      { mr: "dalan",          en: "gallery" },
    contact:      { mr: "sampark",        en: "contact" },
    volunteer:    { mr: "swayamsevak",    en: "volunteer" },
    donate:       { mr: "dengi",          en: "donate" },
    transparency: { mr: "pardarshakta",   en: "transparency" },
    privacy:      { mr: "privacy",        en: "privacy" },
    terms:        { mr: "terms",          en: "terms" }
  }.freeze

  TARGETS = {
    about: "pages#about",
    committee: "pages#committee",
    activities: "activities#index",
    articles: "articles#index",
    events: "events#index",
    gallery: "gallery#index",
    contact: "contact_messages#new",
    volunteer: "volunteers#new",
    donate: "pages#donate",
    transparency: "pages#transparency",
    privacy: "pages#privacy",
    terms: "pages#terms"
  }.freeze
end
