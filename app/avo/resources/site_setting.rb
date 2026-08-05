# एकमेव नोंद (singleton) -- अजून अनिश्चित असलेली सर्व माहिती इथे राहते, जेणेकरून
# डिप्लॉयशिवाय दुरुस्त करता येईल. फक्त प्रशासकांसाठी -- देणगी बँक तपशील आणि 12A/80G
# दावे यांसारखी संवेदनशील/कायदेशीर माहिती इथे आहे. See docs/00-project-brief.md.
class Avo::Resources::SiteSetting < Avo::BaseResource
  self.title = :id

  def visible_on_sidebar
    current_user&.can_manage_users_and_settings?
  end

  def fields
    field :id, as: :id

    field :heading_registration, as: :heading, label: "नोंदणी"
    field :registration_number, as: :text, name: "नोंदणी क्रमांक"
    field :registration_type, as: :text, name: "नोंदणी प्रकार"
    field :registration_date, as: :date, name: "नोंदणी दिनांक"
    field :iso_certification, as: :text, name: "ISO प्रमाणपत्र"
    field :has_12a, as: :boolean, name: "12A आहे का?", help: "प्रमाणपत्र हातात असल्याशिवाय चालू करू नका"
    field :has_80g, as: :boolean, name: "80G आहे का?", help: "प्रमाणपत्र हातात असल्याशिवाय चालू करू नका"

    field :heading_address, as: :heading, label: "पत्ता"
    field :address_line1, as: :text, name: "पत्ता ओळ १"
    field :address_line2, as: :text, name: "पत्ता ओळ २"
    field :city, as: :text, name: "गाव/शहर"
    field :district, as: :text, name: "जिल्हा"
    field :state, as: :text, name: "राज्य"
    field :pincode, as: :text, name: "पिनकोड"
    field :map_embed_url, as: :text, name: "गुगल नकाशा embed URL"

    field :heading_contact, as: :heading, label: "संपर्क"
    field :phone_primary, as: :text, name: "फोन (मुख्य)"
    field :phone_secondary, as: :text, name: "फोन (दुसरा)"
    field :email_public, as: :text, name: "सार्वजनिक ईमेल"
    field :facebook_url, as: :text, name: "फेसबुक"
    field :instagram_url, as: :text, name: "इंस्टाग्राम"
    field :youtube_url, as: :text, name: "युट्यूब"
    field :twitter_url, as: :text, name: "ट्विटर / X"

    field :heading_stats, as: :heading, label: "मुख्यपृष्ठावरील तीन आकडेवारी"
    field :stat_1_value, as: :text, name: "आकडा १ -- मूल्य"
    field :stat_1_label_mr, as: :text, name: "आकडा १ -- लेबल (मराठी)"
    field :stat_1_label_en, as: :text, name: "आकडा १ -- लेबल (इंग्रजी)"
    field :stat_2_value, as: :text, name: "आकडा २ -- मूल्य"
    field :stat_2_label_mr, as: :text, name: "आकडा २ -- लेबल (मराठी)"
    field :stat_2_label_en, as: :text, name: "आकडा २ -- लेबल (इंग्रजी)"
    field :stat_3_value, as: :text, name: "आकडा ३ -- मूल्य"
    field :stat_3_label_mr, as: :text, name: "आकडा ३ -- लेबल (मराठी)"
    field :stat_3_label_en, as: :text, name: "आकडा ३ -- लेबल (इंग्रजी)"

    field :heading_donation, as: :heading, label: "देणगी"
    field :donation_upi_id, as: :text, name: "UPI आयडी"
    field :donation_bank_details, as: :textarea, name: "बँक तपशील"

    field :heading_hero, as: :heading, label: "मुख्यपृष्ठ हिरो छायाचित्र"
    field :hero_image, as: :file, name: "हिरो छायाचित्र", help: "किमान २४०० पिक्सेल रुंद, मूळ आकारात अपलोड करा"
  end
end
