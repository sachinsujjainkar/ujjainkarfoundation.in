# Form submission only -- not an account, no login. See
# prompts/phase-05-static-pages.md, स्वयंसेवक.
class Volunteer < ApplicationRecord
  STATUSES = %w[new contacted active inactive].freeze

  validates :name, presence: true
  validates :phone, presence: true, format: { with: /\A[6-9]\d{9}\z/, allow_blank: true }
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP, allow_blank: true }
  validates :status, inclusion: { in: STATUSES }

  before_validation { self.status ||= "new" }
end
