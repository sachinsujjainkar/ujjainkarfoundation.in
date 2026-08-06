class CreateEventPhotoCaptionTranslationsForMobilityTableBackend < ActiveRecord::Migration[8.1]
  def change
    create_table :event_photo_translations do |t|
      # Translated attribute(s)
      t.string :caption

      t.string :locale, null: false
      t.references :event_photo, null: false, foreign_key: true, index: false

      t.timestamps null: false
    end

    add_index :event_photo_translations, :locale, name: :index_event_photo_translations_on_locale
    add_index :event_photo_translations, [ :event_photo_id, :locale ], name: :index_event_photo_translations_on_event_photo_id_and_locale, unique: true
  end
end
