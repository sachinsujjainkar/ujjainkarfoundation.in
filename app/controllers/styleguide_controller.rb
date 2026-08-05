# Development-only component gallery. The route itself only exists in
# development (config/routes.rb); this check is a second guard in case that
# ever changes.
class StyleguideController < ApplicationController
  before_action :require_development!

  def index
  end

  private

  def require_development!
    head :not_found unless Rails.env.development?
  end
end
