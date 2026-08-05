# A Person's role on one Committee. role_title lives here, not on Person --
# see prompts/phase-05-static-pages.md: someone can hold a different title
# on different committees (or across terms).
class Membership < ApplicationRecord
  extend Mobility
  translates :role_title, backend: :table

  belongs_to :committee
  belongs_to :person

  validates :role_title_mr, presence: true
end
