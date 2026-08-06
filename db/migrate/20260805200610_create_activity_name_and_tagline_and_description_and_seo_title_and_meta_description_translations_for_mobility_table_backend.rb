class CreateActivityNameAndTaglineAndDescriptionAndSeoTitleAndMetaDescriptionTranslationsForMobilityTableBackend < ActiveRecord::Migration[8.1]
  def change
    create_table :activity_translations do |t|
      # Translated attribute(s)
      t.string :name
      t.string :tagline
      t.text :description
      t.string :seo_title
      t.text :meta_description

      t.string :locale, null: false
      t.references :activity, null: false, foreign_key: true, index: false

      t.timestamps null: false
    end

    add_index :activity_translations, :locale, name: :index_activity_translations_on_locale
    add_index :activity_translations, [ :activity_id, :locale ], name: :index_activity_translations_on_activity_id_and_locale, unique: true
  end
end
