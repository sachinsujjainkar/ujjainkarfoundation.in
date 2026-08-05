# व्यक्ती -- office bearers and anyone mentioned in an article (Phase 09).
# See docs/03-data-model.md.
class Avo::Resources::Person < Avo::BaseResource
  self.title = :name_mr

  def fields
    field :id, as: :id
    field :name_mr, as: :text, name: "नाव (मराठी)", required: true
    field :name_en, as: :text, name: "नाव (इंग्रजी)"
    field :honorific_mr, as: :text, name: "मान (मराठी)", help: "उदा. डॉ., श्री., सौ."
    field :honorific_en, as: :text, name: "मान (इंग्रजी)"
    field :slug, as: :text, name: "स्लग (URL)", readonly: true, help: "नावावरून आपोआप तयार होते"
    field :bio_mr, as: :textarea, name: "परिचय (मराठी)"
    field :bio_en, as: :textarea, name: "परिचय (इंग्रजी)"
    field :photo, as: :file, name: "छायाचित्र"
    field :city, as: :text, name: "गाव/शहर"

    field :heading_committee, as: :heading, label: "कार्यकारणी तपशील"
    field :committee_member, as: :boolean, name: "कार्यकारणी सदस्य आहे का?"
    field :position_order, as: :number, name: "क्रम"
    field :term_start, as: :date, name: "कार्यकाळ सुरुवात"
    field :term_end, as: :date, name: "कार्यकाळ समाप्ती"

    field :heading_private, as: :heading, label: "फक्त प्रशासकांसाठी -- सार्वजनिक पानावर कधीही दिसणार नाही"
    field :phone, as: :text, name: "फोन (खाजगी)"
    field :email, as: :text, name: "ईमेल (खाजगी)"

    field :memberships, as: :has_many, name: "समितीतील सहभाग"
    field :committees, as: :has_many, through: :memberships, name: "समित्या"
  end
end
