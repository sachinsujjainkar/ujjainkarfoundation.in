# Converts Latin digits to Devanagari digits, for prose. Never used on form
# inputs or admin tables -- Latin numerals stay there because they're easier
# to scan; see docs/prompts/phase-02-i18n.md, "Localised formatting."
class DevanagariNumerals
  DIGIT_MAP = {
    "0" => "०", "1" => "१", "2" => "२", "3" => "३", "4" => "४",
    "5" => "५", "6" => "६", "7" => "७", "8" => "८", "9" => "९"
  }.freeze

  def self.convert(value)
    value.to_s.gsub(/\d/) { |digit| DIGIT_MAP.fetch(digit) }
  end
end
