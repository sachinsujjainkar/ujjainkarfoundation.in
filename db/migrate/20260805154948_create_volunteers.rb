class CreateVolunteers < ActiveRecord::Migration[8.1]
  def change
    create_table :volunteers do |t|
      t.string :name, null: false
      t.string :phone, null: false
      t.string :email
      t.string :taluka
      # docs/03-data-model.md specifies interest_area_id -> Activity, but the
      # Activity model doesn't exist until Phase 08 -- a plain string of the
      # area's slug (config/locales/{mr,en}/activities.yml) for now. Swap
      # for a real FK when Phase 08 lands; the slugs already match.
      t.string :interest_area
      t.text :message
      t.string :status, null: false, default: "new"

      t.timestamps
    end
  end
end
