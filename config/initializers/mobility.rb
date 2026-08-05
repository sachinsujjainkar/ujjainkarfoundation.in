Mobility.configure do
  # PLUGINS
  plugins do
    # Backend
    #
    # :table -- a `<model>_translations` table per translated model, one row
    # per (record, locale). Chosen over :key_value's shared, polymorphic
    # translations tables for query-ability and simplicity at this project's
    # scale: see docs/03-data-model.md, "Translated fields use Mobility
    # (:table backend -- a _translations table per model)".
    #
    backend :table

    # ActiveRecord
    #
    # Defines ActiveRecord as ORM, and enables ActiveRecord-specific plugins.
    active_record

    # Accessors
    #
    # Define reader and writer methods for translated attributes. Remove either
    # to disable globally, or pass +reader: false+ or +writer: false+ to
    # +translates+ in any translated model.
    #
    reader
    writer

    # Backend Reader
    #
    # Defines reader to access the backend for any attribute, of the form
    # +<attribute>_backend+.
    #
    backend_reader
    #
    # Or pass an interpolation string to define a different pattern:
    # backend_reader "%s_translations"

    # Query
    #
    # Defines a scope on the model class which allows querying on
    # translated attributes. The default scope is named +i18n+, pass a different
    # name as default to change the global default, or to +translates+ in any
    # model to change it for that model alone.
    #
    query

    # Cache
    #
    # Comment out to disable caching reads and writes.
    #
    cache

    # Dirty
    #
    # Uncomment this line to include and enable globally:
    # dirty
    #
    # Or uncomment this line to include but disable by default, and only enable
    # per model by passing +dirty: true+ to +translates+.
    # dirty false

    # Column Fallback
    #
    # Uncomment line below to fallback to original column. You can pass
    # +column_fallback: true+ to +translates+ to return original column on
    # default locale, or pass +column_fallback: [:en, :de]+ to +translates+
    # to return original column for those locales or pass
    # +column_fallback: ->(locale) { ... }+ to +translates to evaluate which
    # locales to return original column for.
    # column_fallback
    #
    # Or uncomment this line to enable column fallback with a global default.
    # column_fallback true

    # Fallbacks
    #
    # en -> mr, never mr -> en. Marathi is the source of record: every
    # article requires it, so a missing mr value means the record is
    # broken. A missing en value is normal editorial policy (English is
    # optional per article) -- show the Marathi content with a notice at
    # the view layer, don't silently fall back the other direction.
    fallbacks(en: :mr)

    # Presence
    #
    # Converts blank strings to nil on reads and writes. Comment out to
    # disable.
    #
    presence

    # Default
    #
    # Set a default translation per attributes. When enabled, passing +default:
    # 'foo'+ sets a default translation string to show in case no translation is
    # present. Can also be passed a proc.
    #
    # default 'foo'

    # Fallthrough Accessors
    #
    # Uses method_missing to define locale-specific accessor methods like
    # +title_en+, +title_en=+, +title_fr+, +title_fr=+ for each translated
    # attribute. If you know what set of locales you want to support, it's
    # generally better to use Locale Accessors (or both together) since
    # +method_missing+ is very slow.  (You can use both fallthrough and locale
    # accessor plugins together without conflict.)
    #
    # fallthrough_accessors

    # Locale Accessors
    #
    # Defines e.g. +headline_mr+ / +headline_en+ directly, for the two
    # locales this project actually has (rather than relying on
    # I18n.available_locales, which is also just [:mr, :en] here, but this
    # is more explicit and doesn't shift if that ever changes).
    #
    locale_accessors [ :mr, :en ]

    # Attribute Methods
    #
    # Adds translated attributes to +attributes+ hash, and defines methods
    # +translated_attributes+ and +untranslated_attributes+ which return hashes
    # with translated and untranslated attributes, respectively. Be aware that
    # this plugin can create conflicts with other gems.
    #
    # attribute_methods
  end
end
