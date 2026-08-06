class CreateEvents < ActiveRecord::Migration[8.1]
  def change
    create_table :events do |t|
      # Simple Latin-transliterated slug (like Activity/Person), not
      # Article's numeric-id-prefix scheme -- docs/04-routes.md writes
      # this as plain "/mr/karyakram/:slug", no id-slug combo.
      t.string :slug, null: false
      t.datetime :starts_at
      t.datetime :ends_at
      t.string :venue_name
      t.text :venue_address
      # Nullable -- not every event belongs to a specific कार्यक्षेत्र.
      t.references :activity, null: true, foreign_key: true
      t.boolean :published, null: false, default: false
      t.string :youtube_id

      t.timestamps
    end
    add_index :events, :slug, unique: true
    add_index :events, :starts_at
  end
end
