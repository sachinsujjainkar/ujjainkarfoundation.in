class CreateCommitteeNameTranslationsForMobilityTableBackend < ActiveRecord::Migration[8.1]
  def change
    create_table :committee_translations do |t|
      # Translated attribute(s)
      t.string :name

      t.string :locale, null: false
      t.references :committee, null: false, foreign_key: true, index: false

      t.timestamps null: false
    end

    add_index :committee_translations, :locale, name: :index_committee_translations_on_locale
    add_index :committee_translations, [ :committee_id, :locale ], name: :index_committee_translations_on_committee_id_and_locale, unique: true
  end
end
