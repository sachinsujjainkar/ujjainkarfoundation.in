# स्वयंसेवक नोंदणी फॉर्मद्वारे आलेल्या नोंदी -- खाते नाही, लॉगिन नाही.
class Avo::Resources::Volunteer < Avo::BaseResource
  self.title = :name

  STATUS_LABELS_MR = { "new" => "नवीन", "contacted" => "संपर्क केला", "active" => "सक्रिय", "inactive" => "निष्क्रिय" }.freeze

  def fields
    field :id, as: :id
    field :name, as: :text, name: "नाव", readonly: true
    field :phone, as: :text, name: "मोबाईल", readonly: true
    field :email, as: :text, name: "ईमेल", readonly: true
    field :taluka, as: :text, name: "तालुका", readonly: true
    field :interest_area, as: :text, name: "आवडीचे क्षेत्र", readonly: true
    field :message, as: :textarea, name: "संदेश", readonly: true
    field :status, as: :select, name: "स्थिती", options: STATUS_LABELS_MR.invert
    field :created_at, as: :date_time, name: "नोंदणी दिनांक", readonly: true
  end
end
