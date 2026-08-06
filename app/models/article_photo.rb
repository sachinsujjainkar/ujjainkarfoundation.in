# Press photo attached to an Article -- exactly what Photoable
# (app/models/concerns/photoable.rb) was built for in Phase 06, with no
# includer until now. Caption is translated CONTENT ("डावीकडून: ..."),
# not alt text.
class ArticlePhoto < ApplicationRecord
  include Photoable

  belongs_to :article
end
