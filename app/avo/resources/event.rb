# कार्यक्रम -- a dated event. upcoming/past shown on the public site is
# derived from starts_at, not a field here.
class Avo::Resources::Event < Avo::BaseResource
  self.title = :title_mr

  def fields
    field :id, as: :id
    field :slug, as: :text, name: "स्लग (URL)", readonly: true, help: "शीर्षकावरून आपोआप तयार होते"
    field :published, as: :boolean, name: "प्रकाशित आहे का?"

    tabs do
      tab "मराठी", description: "आवश्यक" do
        field :title_mr, as: :text, name: "शीर्षक", required: true
        field :description_mr, as: :trix, name: "वर्णन"
        field :venue_note_mr, as: :text, name: "स्थळ टीप", help: "उदा. सभागृहाबद्दल अतिरिक्त माहिती"
      end

      tab "इंग्रजी", description: "ऐच्छिक" do
        field :title_en, as: :text, name: "Title"
        field :description_en, as: :trix, name: "Description"
        field :venue_note_en, as: :text, name: "Venue note"
      end
    end

    field :heading_when_where, as: :heading, label: "दिनांक व स्थळ"
    field :starts_at, as: :date_time, name: "सुरुवात"
    field :ends_at, as: :date_time, name: "समाप्ती"
    field :venue_name, as: :text, name: "स्थळाचे नाव"
    field :venue_address, as: :textarea, name: "पत्ता"
    field :activity, as: :belongs_to, name: "कार्यक्षेत्र", help: "ऐच्छिक -- लागू असल्यास"

    field :heading_media, as: :heading, label: "छायाचित्रे व व्हिडिओ"
    field :hero_image, as: :file, name: "मुख्य छायाचित्र"
    field :youtube_id, as: :text, name: "YouTube व्हिडिओ आयडी", help: "पूर्ण URL नाही -- फक्त आयडी भाग, उदा. dQw4w9WgXcQ"
    field :event_photos, as: :has_many, name: "छायाचित्र दालन"

    field :articles, as: :has_many, name: "संबंधित बातम्या", help: "या कार्यक्रमाचे वृत्तांकन करणाऱ्या बातम्या"
  end
end
