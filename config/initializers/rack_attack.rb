# Throttles the two public form endpoints (संपर्क, स्वयंसेवक) and the staff
# login -- see docs/06-infrastructure.md, "rack-attack on all public forms
# and the login endpoint," prompts/phase-05-static-pages.md, and
# prompts/phase-07-admin-auth.md. hCaptcha isn't wired in yet (no site/
# secret key available); this is the interim guard on the forms.
class Rack::Attack
  THROTTLED_PATHS = %w[/mr/sampark /en/contact /mr/swayamsevak /en/volunteer].freeze

  throttle("forms/ip", limit: 5, period: 1.minute) do |request|
    request.ip if request.post? && THROTTLED_PATHS.include?(request.path)
  end

  # Login itself also has SessionsController's own class-level rate_limit
  # (10/3min, Rails 8 built-in, keyed per email+IP via Rails.cache) -- this
  # is the coarser, IP-only outer guard the phase brief specifically asks
  # for. Being stricter (5/20min) it's usually the one that actually fires.
  throttle("login/ip", limit: 5, period: 20.minutes) do |request|
    request.ip if request.post? && request.path == "/session"
  end
end
