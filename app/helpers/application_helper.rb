module ApplicationHelper
  # Single source of truth for the org's name, in the current locale --
  # the full legal name (शिवचरण उज्जैनकर फाउंडेशन), not the shorthand.
  def site_name
    I18n.locale == :mr ? "शिवचरण उज्जैनकर फाउंडेशन" : "Shivcharan Ujjainkar Foundation"
  end

  # The header/mobile-nav wordmark stays in Devanagari regardless of
  # locale -- it's a logotype, not translated body text (the placeholder
  # noted in prompts/phase-03-layout-shell.md is Marathi-only until the
  # real lockup exists).
  def brand_wordmark
    "शिवचरण उज्जैनकर फाउंडेशन"
  end

  # Maps Rails' own flash keys (:notice, :alert) and this app's own
  # (:success, :warn, :danger) onto the flash component's three variants.
  FLASH_TYPES = {
    "notice" => :success, "success" => :success,
    "warning" => :warn, "warn" => :warn,
    "alert" => :danger, "error" => :danger, "danger" => :danger
  }.freeze

  def flash_type(key)
    FLASH_TYPES.fetch(key.to_s, :success)
  end

  # Path for a symbolic page name (see LocalizedPages::SEGMENTS), in the
  # CURRENT locale -- e.g. localized_path(:about) is /mr/aamchyavishayi or
  # /en/about depending on I18n.locale. Nav/footer links use this instead of
  # picking a locale-specific route helper by hand.
  #
  # `name` is validated against the known route set before being spliced
  # into a send -- every call site here passes a literal symbol today, but
  # this keeps it that way rather than trusting callers forever.
  def localized_path(name)
    raise ArgumentError, "unknown page #{name.inspect}" unless LocalizedPages::SEGMENTS.key?(name.to_sym)

    send("#{I18n.locale}_#{name}_path")
  end

  # Primary nav items, in the fixed order from docs/prompts/phase-03-layout-shell.md.
  def nav_items
    %i[home about activities events articles gallery contact]
  end

  # :home isn't a LocalizedPages entry (it's the plain locale root), so it
  # needs its own path lookup; everything else goes through localized_path.
  def nav_path(name)
    name == :home ? locale_root_path : localized_path(name)
  end

  # The URL for the *same record*, in another locale -- reuses the exact
  # params (controller, action, id/slug, query string) that matched the
  # current request and just swaps :locale. This is how the language
  # switcher and hreflang tags avoid ever dumping the visitor on the
  # homepage: see docs/04-routes.md, "the language switcher maps between
  # them by ID, never by dumping the user on the homepage."
  def alternate_locale_url(locale, only_path: false)
    locale = locale.to_sym
    raise ArgumentError, "unknown locale #{locale.inspect}" unless I18n.available_locales.include?(locale)

    # LocalizedPages routes (config/routes.rb) carry a locale_page default
    # because their path segment is a different translated word per locale
    # (aamchyavishayi vs about) -- url_for can't swap :locale for those the
    # way it can for a real dynamic segment, so dispatch to the other
    # locale's named route directly. `page` comes from route defaults (only
    # ever one of LocalizedPages::SEGMENTS' own keys, never a request
    # param), but it's still validated here before being spliced into a
    # send, the same as `locale` above.
    page = request.path_parameters[:locale_page]
    if page && LocalizedPages::SEGMENTS.key?(page.to_sym)
      return send("#{locale}_#{page}_#{only_path ? :path : :url}")
    end

    url_for(params.to_unsafe_h.merge(locale: locale, only_path: only_path))
  rescue ActionController::UrlGenerationError
    # The current page has no equivalent in that locale (shouldn't happen
    # once real content routes exist with shared IDs, but fails safe).
    only_path ? locale_root_path(locale: locale) : locale_root_url(locale: locale)
  end
end
