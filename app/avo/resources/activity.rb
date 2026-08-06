# कार्यक्षेत्र -- one of the six standing areas of work.
class Avo::Resources::Activity < Avo::BaseResource
  self.title = :name_mr

  ICON_LABELS_MR = {
    "book" => "पुस्तक (साहित्य संमेलन)",
    "award" => "पदक (पुरस्कार)",
    "graduation_cap" => "पदवी टोपी (विद्यार्थी सत्कार)",
    "podium" => "व्यासपीठ (व्याख्यानमाला)",
    "document" => "दस्तऐवज (प्रकाशन)",
    "heart" => "हृदय (आरोग्य व सामाजिक उपक्रम)"
  }.freeze

  def fields
    field :id, as: :id
    field :name_mr, as: :text, name: "नाव (मराठी)", required: true
    field :name_en, as: :text, name: "नाव (इंग्रजी)"
    field :slug, as: :text, name: "स्लग (URL)", help: "एकदा ठरल्यावर बदलू नये -- सार्वजनिक लिंक्स तुटतील"
    field :tagline_mr, as: :text, name: "टॅगलाईन (मराठी)", help: "एक ओळ, कार्डवर दिसते"
    field :tagline_en, as: :text, name: "टॅगलाईन (इंग्रजी)"
    field :description_mr, as: :textarea, name: "वर्णन (मराठी)"
    field :description_en, as: :textarea, name: "वर्णन (इंग्रजी)"
    field :hero_image, as: :file, name: "मुख्य छायाचित्र"
    field :icon_key, as: :select, name: "चिन्ह", options: ICON_LABELS_MR.invert,
      help: "app/views/home/_activity_icon.html.erb मधील उपलब्ध चिन्हे"
    field :position, as: :number, name: "क्रम", help: "पानावर दाखवण्याचा क्रम"
    field :published, as: :boolean, name: "प्रकाशित आहे का?"

    field :heading_seo, as: :heading, label: "SEO (ऐच्छिक)"
    field :seo_title_mr, as: :text, name: "SEO शीर्षक (मराठी)"
    field :seo_title_en, as: :text, name: "SEO शीर्षक (इंग्रजी)"
    field :meta_description_mr, as: :textarea, name: "Meta वर्णन (मराठी)"
    field :meta_description_en, as: :textarea, name: "Meta वर्णन (इंग्रजी)"
  end
end
