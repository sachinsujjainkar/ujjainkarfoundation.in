class CreateArticles < ActiveRecord::Migration[8.1]
  def change
    create_table :articles do |t|
      # Latin transliteration + numeric ID prefix, frozen after create --
      # docs/01-glossary.md, "Slug policy". Uniqueness enforced at the DB
      # level even though the numeric prefix already guarantees it in
      # practice (defense in depth, same reasoning as every other slug
      # column in this app).
      t.string :slug, null: false
      # "पुणे" -- renders with published_at as "पुणे, दि. ५ ऑगस्ट".
      t.string :dateline_place
      t.datetime :published_at
      t.boolean :featured, null: false, default: false
      t.boolean :needs_english_translation, null: false, default: false
      t.integer :view_count, null: false, default: 0
      # बैठक वृत्त/पुरस्कार/निवड व नियुक्ती/कार्यक्रम वृत्त/निवेदन/उपक्रम वृत्त --
      # explicit integer mapping declared in the model, matching User#role's
      # convention (never enum's array-index default).
      t.integer :article_type, null: false
      # मसुदा/पुनरावलोकनासाठी/प्रकाशित/संग्रहित.
      t.integer :status, null: false, default: 0

      # references :author, not :user -- "author" is the byline role, not
      # a generic user reference; class_name set in the model since Rails
      # can't infer User from "author" by convention.
      t.references :author, null: false, foreign_key: { to_table: :users }
      t.bigint :published_by_id
      # Nullable -- most articles won't belong to a specific कार्यक्षेत्र.
      t.references :activity, null: true, foreign_key: true
      # event_id -> Event is Phase 10's column to add (Event doesn't exist
      # yet -- a real FK constraint can't reference a table that isn't
      # there). See docs/03-data-model.md.

      t.timestamps
    end
    add_index :articles, :slug, unique: true
    add_index :articles, :published_at
    add_index :articles, :published_by_id
  end
end
