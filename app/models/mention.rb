# Join: which व्यक्ती are named in which बातमी. This is the "quiet
# differentiator" docs/03-data-model.md calls out -- gives every mentioned
# person an automatic page listing everything they've been mentioned in.
class Mention < ApplicationRecord
  belongs_to :article
  belongs_to :person

  validates :person_id, uniqueness: { scope: :article_id }
end
