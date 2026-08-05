module ApplicationHelper
  # The URL for the *same record*, in another locale -- reuses the exact
  # params (controller, action, id/slug, query string) that matched the
  # current request and just swaps :locale. This is how the language
  # switcher and hreflang tags avoid ever dumping the visitor on the
  # homepage: see docs/04-routes.md, "the language switcher maps between
  # them by ID, never by dumping the user on the homepage."
  def alternate_locale_url(locale, only_path: false)
    url_for(params.to_unsafe_h.merge(locale: locale, only_path: only_path))
  rescue ActionController::UrlGenerationError
    # The current page has no equivalent in that locale (shouldn't happen
    # once real content routes exist with shared IDs, but fails safe).
    only_path ? locale_root_path(locale: locale) : locale_root_url(locale: locale)
  end
end
