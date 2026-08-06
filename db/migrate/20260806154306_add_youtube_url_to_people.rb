# A person's own public channel/profile link -- distinct from
# SiteSetting#youtube_url (the foundation's own channel). Public-facing,
# unlike Person#phone/#email (admin-only, see that model's own comment) --
# rendered as a real link wherever a person's profile shows one.
class AddYoutubeUrlToPeople < ActiveRecord::Migration[8.1]
  def change
    add_column :people, :youtube_url, :string
  end
end
