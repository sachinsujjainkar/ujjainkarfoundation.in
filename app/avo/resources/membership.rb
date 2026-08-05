# एका व्यक्तीचे एका समितीतील पद -- role_title इथे आहे, Person वर नाही, कारण
# एकच व्यक्ती वेगवेगळ्या समितीत वेगळे पद भूषवू शकते.
class Avo::Resources::Membership < Avo::BaseResource
  self.title = :role_title_mr

  def fields
    field :id, as: :id
    field :committee, as: :belongs_to, name: "समिती", required: true
    field :person, as: :belongs_to, name: "व्यक्ती", required: true
    field :role_title_mr, as: :text, name: "पदनाम (मराठी)", required: true, help: "उदा. अध्यक्ष, सचिव"
    field :role_title_en, as: :text, name: "पदनाम (इंग्रजी)"
    field :position_order, as: :number, name: "क्रम"
  end
end
