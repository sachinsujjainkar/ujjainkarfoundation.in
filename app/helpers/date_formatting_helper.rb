module DateFormattingHelper
  # Marathi prose date: "५ ऑगस्ट २०२६" -- Marathi month name, Devanagari
  # numerals for day and year. Distinct from I18n.l (config/locales/mr/datetime.yml),
  # which stays Latin-numeral on purpose for form inputs and admin tables.
  def marathi_date(date)
    return "" if date.blank?

    "#{DevanagariNumerals.convert(date.day)} #{marathi_month_name(date)} #{DevanagariNumerals.convert(date.year)}"
  end

  # Locale-aware convenience for prose dates: Marathi press style in :mr,
  # standard I18n.l elsewhere. Use marathi_date/dateline directly for text
  # that's Marathi regardless of the current locale (like Article#dateline_place).
  def localized_date(date)
    return "" if date.blank?

    I18n.locale == :mr ? marathi_date(date) : I18n.l(date, format: :long)
  end

  # Standard Marathi newspaper dateline: "पुणे, दि. ५ ऑगस्ट" -- place, "दि."
  # (दिनांक, short form), day and month. No year -- a dateline is implicitly
  # "today" in press convention. See docs/03-data-model.md, Article#dateline_place;
  # Phase 09 depends on this helper.
  def dateline(place, date)
    return place.to_s if date.blank?

    "#{place}, दि. #{DevanagariNumerals.convert(date.day)} #{marathi_month_name(date)}"
  end

  # [day, month] for the event "date chip" card (components/_card_event) --
  # Devanagari day number, Marathi abbreviated month name. Locale-aware
  # like localized_date -- Latin numerals and English abbreviation in :en.
  def event_date_chip(date)
    return [ "", "" ] if date.blank?
    return [ date.day.to_s, I18n.t("date.abbr_month_names")[date.month] ] unless I18n.locale == :mr

    [ DevanagariNumerals.convert(date.day), I18n.t("date.abbr_month_names", locale: :mr)[date.month] ]
  end

  private

  def marathi_month_name(date)
    I18n.t("date.month_names", locale: :mr)[date.month]
  end
end
