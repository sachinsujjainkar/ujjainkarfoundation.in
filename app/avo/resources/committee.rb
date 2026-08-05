# समिती -- one of the foundation's three concurrent committees.
class Avo::Resources::Committee < Avo::BaseResource
  self.title = :name_mr

  def fields
    field :id, as: :id
    field :name_mr, as: :text, name: "नाव (मराठी)", required: true
    field :name_en, as: :text, name: "नाव (इंग्रजी)"
    field :position, as: :number, name: "क्रम", help: "पानावर दाखवण्याचा क्रम"
    field :memberships, as: :has_many, name: "सदस्य नोंदी"
    field :people, as: :has_many, through: :memberships, name: "सदस्य"
  end
end
