# Staff only -- no public registration route exists anywhere in this app
# (see config/routes.rb: only `resource :session` and `resources :passwords`
# are routed; there is no `resources :users` for self-signup). Accounts are
# created by an admin, through Avo. See docs/00-project-brief.md, "Roles",
# and docs/03-data-model.md.
class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  # Explicit integer mapping, not enum's default array-index assignment --
  # a DB value must never silently change meaning if this list is
  # reordered later. Least-privileged (reporter) is 2, matching the
  # migration's literal default.
  enum :role, { admin: 0, editor: 1, reporter: 2 }

  validates :name, presence: true
  validates :email_address, presence: true

  ROLE_LABELS_MR = { "admin" => "प्रशासक", "editor" => "संपादक", "reporter" => "वार्ताहर" }.freeze

  def role_label_mr
    ROLE_LABELS_MR.fetch(role)
  end

  # The small can_*? matrix from prompts/phase-07-admin-auth.md's role
  # table -- deliberately not a permissions gem, this is the whole thing:
  #
  #                        | reporter | editor | admin |
  #   Create article       |    ✓     |   ✓    |   ✓   |
  #   Edit own draft       |    ✓     |   ✓    |   ✓   |
  #   Edit others'         |    —     |   ✓    |   ✓   |
  #   Publish / unpublish  |    —     |   ✓    |   ✓   |
  #   Delete               |    —     |   —    |   ✓   |
  #   Users & settings     |    —     |   —    |   ✓   |
  #
  # "Create article" and "edit own draft" need no method -- every role can,
  # so there's nothing to gate.
  def can_edit_others_work?
    admin? || editor?
  end

  def can_publish?
    admin? || editor?
  end

  def can_delete?
    admin?
  end

  def can_manage_users_and_settings?
    admin?
  end

  # Called on successful login (SessionsController) rather than on every
  # request -- last_seen_at is a staff-dashboard signal ("who's actually
  # using this"), not a security-critical timestamp, so it doesn't need
  # per-request write amplification.
  def touch_last_seen!
    update_column(:last_seen_at, Time.current)
  end
end
