# व्यक्ती -- office bearers and anyone mentioned in an article (Phase 09).
# See docs/03-data-model.md.
class Avo::Resources::Person < Avo::BaseResource
  self.title = :name_mr
  # Powers the searchable belongs_to picker on Mention's admin form
  # (app/avo/resources/mention.rb) -- reporters routinely tag twenty-plus
  # people per article (prompts/phase-09-newsroom.md, "Watch for"), so
  # finding someone by typing their name, not scrolling an ID list, matters.
  self.search = {
    query: -> { query.where("name_mr ILIKE :q OR name_en ILIKE :q", q: "%#{params[:q]}%") }
  }

  def fields
    field :id, as: :id
    field :name_mr, as: :text, name: "नाव (मराठी)", required: true
    field :name_en, as: :text, name: "नाव (इंग्रजी)"
    field :honorific_mr, as: :text, name: "मान (मराठी)", help: "उदा. डॉ., श्री., सौ."
    field :honorific_en, as: :text, name: "मान (इंग्रजी)"
    field :slug, as: :text, name: "स्लग (URL)", readonly: true, help: "नावावरून आपोआप तयार होते"
    # Plain textarea, not Trix -- bio is a Mobility-translated column, not
    # Action Text, same structural reason Article#body couldn't use
    # Mobility either (see app/models/article.rb's own comment). Rendered
    # via sanitize() on the public About page (app/views/pages/about.html.erb),
    # so <p>/<strong>/<blockquote>/<br> here become real formatting rather
    # than literal escaped text -- anything else typed here is stripped on
    # render, not just ignored by this form.
    field :bio_mr, as: :textarea, name: "परिचय (मराठी)",
      help: "साधे परिच्छेद पुरेसे आहेत. जोर देण्यासाठी <strong>..</strong>, अवतरणासाठी <blockquote>..</blockquote> वापरता येते."
    field :bio_en, as: :textarea, name: "परिचय (इंग्रजी)"
    field :photo, as: :file, name: "छायाचित्र"
    field :city, as: :text, name: "गाव/शहर"
    field :youtube_url, as: :text, name: "यूट्यूब चॅनेल", help: "या व्यक्तीचे स्वतःचे चॅनेल -- फाउंडेशनचे चॅनेल Site Settings मध्ये वेगळे आहे"

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
