# Rails' exceptions_app (config/application.rb) dispatches here for
# unhandled exceptions, via unprefixed /404 and /500 -- so, unlike every
# other controller, params[:locale] doesn't exist and the normal set_locale
# before_action can't run. Best-effort recover the locale from whatever
# request actually failed, falling back the same way root/ does.
class ErrorsController < ApplicationController
  skip_before_action :set_locale
  before_action :set_locale_from_failed_request

  def not_found
    render status: :not_found
  end

  def internal_server_error
    render status: :internal_server_error
  end

  private

  def set_locale_from_failed_request
    original_path = request.env["action_dispatch.original_path"] || request.path
    segment = original_path.to_s.split("/")[1]

    I18n.locale = segment.presence_in(I18n.available_locales.map(&:to_s)) || PreferredLocale.for(request)
  end
end
