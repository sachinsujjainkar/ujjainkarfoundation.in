# Staff login only -- not part of the public site (ApplicationController
# deliberately does not include Authentication; see its comment). This
# controller opts in directly, since it's the one place the concern's
# require_authentication/allow_unauthenticated_access actually apply.
#
# rack-attack (config/initializers/rack_attack.rb) throttles POST /session
# to 5/20min per IP, ahead of this class-level rate_limit's 10/3min --
# belt and suspenders, per prompts/phase-07-admin-auth.md's explicit
# "rack-attack on login" requirement plus Rails 8's own built-in guard.
class SessionsController < ApplicationController
  include Authentication
  layout "admin"

  allow_unauthenticated_access only: %i[ new create ]
  rate_limit to: 10, within: 3.minutes, only: :create, with: -> { redirect_to new_session_path, alert: t("auth.try_again_later") }

  def new
  end

  def create
    user = User.authenticate_by(params.permit(:email_address, :password))

    if user.nil?
      redirect_to new_session_path, alert: t("auth.invalid_credentials")
    elsif !user.active?
      redirect_to new_session_path, alert: t("auth.account_inactive")
    else
      start_new_session_for user
      user.touch_last_seen!
      redirect_to after_authentication_url
    end
  end

  def destroy
    terminate_session
    redirect_to new_session_path, status: :see_other
  end

  private

  # ApplicationController's default_url_options adds ?locale=... for the
  # public site's :locale-scoped routes. session/passwords routes carry no
  # :locale segment (staff-only, not bilingual) -- without this override
  # every redirect here picks up a stray ?locale=mr query param.
  def default_url_options
    {}
  end
end
