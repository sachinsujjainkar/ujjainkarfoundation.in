# Throttles the two public form endpoints (संपर्क, स्वयंसेवक) -- see
# docs/06-infrastructure.md, "rack-attack on all public forms and the
# login endpoint," and prompts/phase-05-static-pages.md. hCaptcha isn't
# wired in yet (no site/secret key available); this is the interim guard.
class Rack::Attack
  THROTTLED_PATHS = %w[/mr/sampark /en/contact /mr/swayamsevak /en/volunteer].freeze

  throttle("forms/ip", limit: 5, period: 1.minute) do |request|
    request.ip if request.post? && THROTTLED_PATHS.include?(request.path)
  end
end
