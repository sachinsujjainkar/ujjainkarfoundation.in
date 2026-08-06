# दालनातील एक छायाचित्र -- ArticlePhoto's twin, same shape, belonging to Event.
class Avo::Resources::EventPhoto < Avo::BaseResource
  self.title = :id

  def fields
    field :id, as: :id
    field :event, as: :belongs_to, name: "कार्यक्रम"
    field :image, as: :file, name: "छायाचित्र"
    field :caption_mr, as: :text, name: "मथळा (मराठी)", help: "उदा. डावीकडून: नाव, नाव..."
    field :caption_en, as: :text, name: "मथळा (इंग्रजी)"
    field :credit, as: :text, name: "छायाचित्रकार"
    field :position, as: :number, name: "क्रम", help: "दालनात दिसण्याचा क्रम"
  end
end
