module Authentication
  extend ActiveSupport::Concern

  included do
    before_action :require_authentication
    helper_method :authenticated?
  end

  class_methods do
    def allow_unauthenticated_access(**options)
      skip_before_action :require_authentication, **options
    end
  end

  private
    def authenticated?
      resume_session
    end

    def require_authentication
      resume_session || request_authentication
    end

    def resume_session
      Current.session ||= find_session_by_cookie
    end

    def find_session_by_cookie
      Session.find_by(id: cookies.signed[:session_id]) if cookies.signed[:session_id]
    end

    def request_authentication
      session[:return_to_after_authenticating] = request.url
      redirect_to new_session_path
    end

    # Rails' generator defaults this to root_url -- fine for an app where
    # the homepage IS the app, wrong here: this login exists purely for
    # staff, and root_url is the public marketing site. Land on the admin
    # panel unless there's a specific page they were bounced here from
    # (e.g. hit an /admin/... URL directly while signed out).
    def after_authentication_url
      session.delete(:return_to_after_authenticating) || "#{request.base_url}/admin"
    end

    def start_new_session_for(user)
      user.sessions.create!(user_agent: request.user_agent, ip_address: request.remote_ip).tap do |session|
        Current.session = session
        # httponly blocks JS access (XSS can't steal the cookie); same_site
        # :lax blocks it being sent cross-site; secure (implied by
        # config.force_ssl in production, set explicitly here too so it's
        # not silently dependent on that staying on) blocks it going out
        # over plain HTTP. See prompts/phase-07-admin-auth.md, "Session
        # security."
        cookies.signed.permanent[:session_id] = {
          value: session.id, httponly: true, same_site: :lax, secure: Rails.env.production?
        }
      end
    end

    def terminate_session
      Current.session.destroy
      cookies.delete(:session_id)
    end
end
