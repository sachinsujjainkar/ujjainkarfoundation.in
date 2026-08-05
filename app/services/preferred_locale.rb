# Resolves which locale an unprefixed "/" request should redirect to.
# Cookie wins if it's already set (a returning visitor's explicit choice);
# otherwise fall back to Accept-Language, and only when it *clearly* prefers
# English -- anything else defaults to :mr, the application default.
class PreferredLocale
  COOKIE_NAME = "locale"

  def self.for(request)
    new(request).resolve
  end

  def initialize(request)
    @request = request
  end

  def resolve
    cookie_locale || (prefers_english? ? "en" : "mr")
  end

  private

  attr_reader :request

  def cookie_locale
    value = request.cookie_jar[COOKIE_NAME]
    value if I18n.available_locales.map(&:to_s).include?(value)
  end

  # "Clearly prefers English" = the highest-priority tag in Accept-Language
  # is en/en-*. A lower-priority "en" mixed in with other languages doesn't
  # count -- Marathi stays the default for anyone who hasn't said otherwise.
  def prefers_english?
    header = request.get_header("HTTP_ACCEPT_LANGUAGE").to_s
    primary_tag = header.split(",").first.to_s.split(";").first.to_s.strip
    primary_tag.downcase.start_with?("en")
  end
end
