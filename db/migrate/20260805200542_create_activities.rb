class CreateActivities < ActiveRecord::Migration[8.1]
  def change
    create_table :activities do |t|
      t.string :slug, null: false
      # References app/views/home/_activity_icon.html.erb's case statement
      # -- six keys exist today (one per confirmed कार्यक्षेत्र), matching
      # Activity::ICON_KEYS in the model.
      t.string :icon_key
      t.integer :position, null: false, default: 0
      t.boolean :published, null: false, default: false

      t.timestamps
    end
    add_index :activities, :slug, unique: true
  end
end
