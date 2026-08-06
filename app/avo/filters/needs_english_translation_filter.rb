# prompts/phase-09-newsroom.md: "needs_english_translation surfaced as a
# filterable queue in admin."
class Avo::Filters::NeedsEnglishTranslationFilter < Avo::Filters::BooleanFilter
  self.name = "इंग्रजी अनुवाद प्रलंबित"

  def apply(request, query, values)
    return query unless values["इंग्रजी अनुवाद प्रलंबित असलेल्या बातम्या"]

    query.where(needs_english_translation: true)
  end

  def options
    { "इंग्रजी अनुवाद प्रलंबित असलेल्या बातम्या" => false }
  end
end
