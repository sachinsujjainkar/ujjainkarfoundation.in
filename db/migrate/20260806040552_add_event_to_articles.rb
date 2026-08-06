# The deferred column from Phase 09: Article's event_id -> Event
# couldn't have a real foreign key constraint until Event existed.
# docs/03-data-model.md: nullable -- most articles aren't event coverage.
class AddEventToArticles < ActiveRecord::Migration[8.1]
  def change
    add_reference :articles, :event, null: true, foreign_key: true
  end
end
