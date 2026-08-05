# Singleton. Everything still unconfirmed (see docs/00-project-brief.md,
# "Still unconfirmed") lives here so it can be corrected without a deploy --
# never hardcoded in a view. Confirmed values are seeded in db/seeds.rb.
class SiteSetting < ApplicationRecord
  validate :only_one_record_allowed, on: :create

  # The one row. Creates it with all-nil/false placeholders on first call so
  # every environment (including a fresh test DB) always has a row to read,
  # without needing a seed to have run first.
  def self.instance
    first || create!
  end

  private

  def only_one_record_allowed
    errors.add(:base, "only one SiteSetting may exist") if SiteSetting.exists?
  end
end
