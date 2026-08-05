class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  before_action :set_locale

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
