# One of the foundation's three concurrent committees -- see
# prompts/phase-05-static-pages.md, कार्यकारणी.
class Committee < ApplicationRecord
  extend Mobility
  translates :name, backend: :table

  has_many :memberships, -> { order(:position_order) }, dependent: :destroy
  has_many :people, through: :memberships

  validates :name_mr, presence: true

  default_scope { order(:position) }
end
