class CreateMentions < ActiveRecord::Migration[8.1]
  def change
    create_table :mentions do |t|
      t.references :article, null: false, foreign_key: true
      t.references :person, null: false, foreign_key: true

      t.timestamps
    end
    add_index :mentions, [ :article_id, :person_id ], unique: true
  end
end
