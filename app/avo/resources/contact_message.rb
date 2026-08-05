# संपर्क फॉर्मद्वारे आलेले संदेश.
class Avo::Resources::ContactMessage < Avo::BaseResource
  self.title = :subject

  def fields
    field :id, as: :id
    field :name, as: :text, name: "नाव", readonly: true
    field :email, as: :text, name: "ईमेल", readonly: true
    field :subject, as: :text, name: "विषय", readonly: true
    field :message, as: :textarea, name: "संदेश", readonly: true
    field :read, as: :boolean, name: "वाचले का?"
    field :created_at, as: :date_time, name: "आलेला दिनांक", readonly: true
  end
end
