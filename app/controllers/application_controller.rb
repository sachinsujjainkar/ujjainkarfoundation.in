class ApplicationController < ActionController::Base
  # Authentication is NOT included here on purpose -- almost every
  # controller in this app serves the public bilingual site and must stay
  # reachable with no login at all (docs/00-project-brief.md: "There is no
  # public registration... 95%+ of traffic" is anonymous visitors). Staff
  # auth is scoped to the admin surface only: Avo's own controllers via
  # config/initializers/avo.rb's authenticate_with, and SessionsController/
  # PasswordsController, which explicitly `include Authentication`
  # themselves where they need it. See app/controllers/concerns/authentication.rb.

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  before_action :set_locale

  # Every footer value (and eventually most contact-ish content) reads from
  # here, never hardcoded -- see docs/00-project-brief.md, "Nothing
  # invented ships." Falls back to an unsaved, all-blank instance if the DB
  # itself is the problem -- the 500 page renders this same layout, and a
  # database outage is a plausible reason to be on it. It must not cascade
  # into a second error.
  helper_method def site_setting
    @site_setting ||= SiteSetting.instance
  rescue StandardError
    SiteSetting.new
  end

  private

  # Every public route is scoped under /:locale (config/routes.rb), so
  # params[:locale] is always present and already constrained to mr|en by
  # the route. Persist it as the visitor's preference so a later bare "/"
  # redirects back to the same locale without re-guessing from
  # Accept-Language. One year, matching the "Persist choice in a cookie,
  # one year" requirement in docs/prompts/phase-02-i18n.md.
  def set_locale
    I18n.locale = params[:locale].presence_in(I18n.available_locales.map(&:to_s)) || I18n.default_locale
    cookies.permanent[:locale] = I18n.locale.to_s
  end

  # Every route/link/form helper carries the current locale automatically,
  # so it's never possible to accidentally drop into an unprefixed URL.
  def default_url_options
    { locale: I18n.locale }
  end
end
