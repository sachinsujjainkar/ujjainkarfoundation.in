class CreateMembershipRoleTitleTranslationsForMobilityTableBackend < ActiveRecord::Migration[8.1]
  def change
    create_table :membership_translations do |t|
      # Translated attribute(s)
      t.string :role_title

      t.string :locale, null: false
      t.references :membership, null: false, foreign_key: true, index: false

      t.timestamps null: false
    end

    add_index :membership_translations, :locale, name: :index_membership_translations_on_locale
    add_index :membership_translations, [ :membership_id, :locale ], name: :index_membership_translations_on_membership_id_and_locale, unique: true
  end
end
