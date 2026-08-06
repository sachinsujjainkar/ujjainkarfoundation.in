class CreateArticlePhotos < ActiveRecord::Migration[8.1]
  def change
    create_table :article_photos do |t|
      t.references :article, null: false, foreign_key: true
      t.integer :position
      t.string :credit

      t.timestamps
    end
  end
end
