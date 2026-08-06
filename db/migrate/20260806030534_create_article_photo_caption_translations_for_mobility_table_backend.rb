class CreateArticlePhotoCaptionTranslationsForMobilityTableBackend < ActiveRecord::Migration[8.1]
  def change
    create_table :article_photo_translations do |t|
      # Translated attribute(s)
      t.string :caption

      t.string :locale, null: false
      t.references :article_photo, null: false, foreign_key: true, index: false

      t.timestamps null: false
    end

    add_index :article_photo_translations, :locale, name: :index_article_photo_translations_on_locale
    add_index :article_photo_translations, [ :article_photo_id, :locale ], name: :index_710f70e92686b769f2cbc779630c9f5dedcb64ee, unique: true
  end
end
