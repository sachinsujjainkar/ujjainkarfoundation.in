class CreateMemberships < ActiveRecord::Migration[8.1]
  def change
    create_table :memberships do |t|
      t.references :committee, null: false, foreign_key: true
      t.references :person, null: false, foreign_key: true
      t.integer :position_order, null: false, default: 0

      t.timestamps
    end
  end
end
