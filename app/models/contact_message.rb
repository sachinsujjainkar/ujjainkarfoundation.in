# See prompts/phase-05-static-pages.md, संपर्क.
class ContactMessage < ApplicationRecord
  validates :name, presence: true
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP, allow_blank: true }
  validates :message, presence: true
end
