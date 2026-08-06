# दालनातील एक छायाचित्र -- Photoable (app/models/concerns/photoable.rb)
# handles the actual attachment/variants; this is just the admin form for
# the fields that live directly on the join.
class Avo::Resources::ArticlePhoto < Avo::BaseResource
  self.title = :id

  def fields
    field :id, as: :id
    field :article, as: :belongs_to, name: "बातमी"
    field :image, as: :file, name: "छायाचित्र"
    field :caption_mr, as: :text, name: "मथळा (मराठी)", help: "उदा. डावीकडून: नाव, नाव..."
    field :caption_en, as: :text, name: "मथळा (इंग्रजी)"
    field :credit, as: :text, name: "छायाचित्रकार"
    field :position, as: :number, name: "क्रम", help: "बातमीत दिसण्याचा क्रम"
  end
end
