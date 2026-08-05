module StyleguideHelper
  # Renders the block twice, once per language, side by side, each inside its
  # own [lang] wrapper and I18n locale. This is how you catch Marathi and
  # English looking wrong at the same nominal size — see
  # docs/02-design-system.md, "Render each in both locales side by side."
  def locale_pair(&block)
    content_tag(:div, class: "grid grid-cols-1 gap-6 md:grid-cols-2") do
      safe_join(%i[mr en].map do |locale|
        content_tag(:div, lang: locale, class: "card") do
          I18n.with_locale(locale) { capture(locale, &block) }
        end
      end)
    end
  end
end
