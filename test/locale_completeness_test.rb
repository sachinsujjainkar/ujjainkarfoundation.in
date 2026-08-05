require "test_helper"

# Cheap to add now, catches drift for years: fails if a key exists in one
# locale's files and not the other's. This is about SITE CHROME (nav,
# buttons, errors...), which must always be bilingual -- do not extend this
# to model content (Article headlines etc.), where Marathi is required and
# English is optional by deliberate editorial policy. See
# docs/00-project-brief.md, "Editorial policy."
class LocaleCompletenessTest < ActiveSupport::TestCase
  # Rails' reserved date/time i18n structure (config/locales/mr/datetime.yml)
  # is excluded on purpose: Rails ships correct English date/time formatting
  # built in, so there's no en/datetime.yml to compare against, and that's
  # not drift. Same reasoning for avo.yml: it's a full translation of the
  # avo gem's own bundled English strings (see that file's header comment),
  # which live in the gem, not in config/locales/en/ -- there's nothing to
  # compare it against in this repo.
  EXCLUDED_FILES = %w[datetime.yml avo.yml].freeze

  test "every key in mr's locale files has a matching key in en, and vice versa" do
    mr_keys = flattened_keys(:mr)
    en_keys = flattened_keys(:en)

    missing_in_en = mr_keys - en_keys
    missing_in_mr = en_keys - mr_keys

    assert_empty missing_in_en, "Present in config/locales/mr/, missing from config/locales/en/: #{missing_in_en.to_a.sort.join(', ')}"
    assert_empty missing_in_mr, "Present in config/locales/en/, missing from config/locales/mr/: #{missing_in_mr.to_a.sort.join(', ')}"
  end

  private

  def flattened_keys(locale)
    dir = Rails.root.join("config", "locales", locale.to_s)
    keys = Set.new

    Dir.glob(dir.join("*.yml")).each do |file|
      next if EXCLUDED_FILES.include?(File.basename(file))

      data = YAML.safe_load_file(file)
      collect_keys(data[locale.to_s], [], keys)
    end

    keys
  end

  def collect_keys(node, prefix, keys)
    if node.is_a?(Hash)
      node.each { |key, value| collect_keys(value, prefix + [ key ], keys) }
    else
      keys << prefix.join(".")
    end
  end
end
