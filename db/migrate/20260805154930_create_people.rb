class CreatePeople < ActiveRecord::Migration[8.1]
  def change
    create_table :people do |t|
      t.string :slug, null: false
      t.string :city
      t.boolean :committee_member, null: false, default: false
      t.integer :position_order, null: false, default: 0
      t.date :term_start
      t.date :term_end
      # Admin-only -- never rendered in a public view. See
      # docs/03-data-model.md, Person: "Never render them in a public view."
      t.string :phone
      t.string :email

      t.timestamps
    end
    add_index :people, :slug, unique: true
  end
end
