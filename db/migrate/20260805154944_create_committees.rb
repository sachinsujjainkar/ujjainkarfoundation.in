class CreateCommittees < ActiveRecord::Migration[8.1]
  def change
    create_table :committees do |t|
      t.integer :position, null: false, default: 0

      t.timestamps
    end
  end
end
