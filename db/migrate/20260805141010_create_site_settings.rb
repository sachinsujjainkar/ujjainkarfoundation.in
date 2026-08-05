class CreateSiteSettings < ActiveRecord::Migration[8.1]
  def change
    create_table :site_settings do |t|
      t.string :registration_number
      t.string :registration_type
      t.date :registration_date
      t.string :iso_certification
      t.string :address_line1
      t.string :address_line2
      t.string :city
      t.string :district
      t.string :state
      t.string :pincode
      t.string :phone_primary
      t.string :phone_secondary
      t.string :email_public
      t.string :map_embed_url
      t.string :facebook_url
      t.string :instagram_url
      t.string :youtube_url
      t.string :twitter_url
      t.string :stat_1_value
      t.string :stat_1_label_mr
      t.string :stat_1_label_en
      t.string :stat_2_value
      t.string :stat_2_label_mr
      t.string :stat_2_label_en
      t.string :stat_3_value
      t.string :stat_3_label_mr
      t.string :stat_3_label_en
      t.string :donation_upi_id
      t.text :donation_bank_details
      t.boolean :has_12a, null: false, default: false
      t.boolean :has_80g, null: false, default: false

      t.timestamps
    end
  end
end
