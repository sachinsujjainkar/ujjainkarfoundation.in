# बातमी संपादक -- "the piece that determines whether the site stays
# alive." prompts/phase-09-newsroom.md. Workflow legality (which status
# transitions are allowed, who may make them) is entirely enforced in the
# model (app/models/article.rb's STATUS_TRANSITIONS/GATED_STATUSES,
# checked against Current.user) -- this form doesn't re-implement any of
# that; an illegal save just comes back with the model's own Marathi
# error message, the same way any other validation failure would.
class Avo::Resources::Article < Avo::BaseResource
  self.title = :headline_mr

  def filters
    filter Avo::Filters::NeedsEnglishTranslationFilter
  end

  def actions
    action Avo::Actions::GeneratePoster
  end

  STATUS_LABELS_MR = {
    "draft" => "मसुदा", "submitted" => "पुनरावलोकनासाठी", "published" => "प्रकाशित", "archived" => "संग्रहित"
  }.freeze

  def fields
    field :id, as: :id
    field :status, as: :select, name: "स्थिती", options: STATUS_LABELS_MR.invert
    field :author, as: :belongs_to, name: "लेखक"
    field :published_at, as: :date_time, name: "प्रकाशन दिनांक", readonly: true
    field :published_by, as: :belongs_to, name: "कोणी प्रकाशित केले", readonly: true
    field :slug, as: :text, name: "स्लग (URL)", readonly: true, help: "मथळ्यावरून आपोआप तयार होते, कायमचे निश्चित"

    tabs do
      tab "मराठी", description: "आवश्यक -- साइटची मूळ भाषा" do
        field :headline_mr, as: :text, name: "मुख्य मथळा", required: true
        field :subheadline_mr, as: :text, name: "उपशीर्षक", help: "मथळ्याखालील एक ओळ -- मराठी वृत्तपत्रांची पद्धत"
        field :body_mr, as: :trix, name: "मजकूर", required: true
        field :seo_title_mr, as: :text, name: "SEO शीर्षक"
        field :meta_description_mr, as: :textarea, name: "Meta वर्णन"
      end

      tab "इंग्रजी", description: "ऐच्छिक -- रिकामे असल्यास इंग्रजी पानावर मराठी मजकूर सूचनेसह दिसतो" do
        field :headline_en, as: :text, name: "Headline"
        field :subheadline_en, as: :text, name: "Subheadline"
        field :body_en, as: :trix, name: "Body"
        field :seo_title_en, as: :text, name: "SEO title"
        field :meta_description_en, as: :textarea, name: "Meta description"
      end
    end

    field :heading_classification, as: :heading, label: "वर्गीकरण"
    field :article_type, as: :select, name: "प्रकार", required: true,
      options: Article.article_types.keys.index_by { |t| I18n.t("articles.types.#{t}", locale: :mr) }
    field :activity, as: :belongs_to, name: "कार्यक्षेत्र", help: "ऐच्छिक -- लागू असल्यास"
    field :event, as: :belongs_to, name: "कार्यक्रम", help: "ऐच्छिक -- एखाद्या कार्यक्रमाचे वृत्तांकन असल्यास"
    field :dateline_place, as: :text, name: "दिनांकरेषा गाव/शहर", help: "उदा. पुणे, मुक्ताईनगर -- वृत्तपत्रांच्या पद्धतीने बातमीच्या सुरुवातीला दिसते"
    field :featured, as: :boolean, name: "ठळक बातमी आहे का?"
    field :needs_english_translation, as: :boolean, name: "इंग्रजी अनुवाद प्रलंबित आहे का?",
      help: "संपादकांना प्रलंबित अनुवादांची यादी दाखवण्यासाठी वापरले जाते"
    field :view_count, as: :number, name: "पाहिले गेले", readonly: true

    field :heading_media, as: :heading, label: "छायाचित्रे व कागदपत्रे"
    field :featured_image, as: :file, name: "मुख्य छायाचित्र"
    field :notice_pdf, as: :file, name: "अधिसूचना (PDF)"
    field :article_photos, as: :has_many, name: "छायाचित्र दालन",
      help: "प्रत्येक छायाचित्राचा क्रम त्याच्या स्वतःच्या संपादन पानावरील 'क्रम' फील्डमधून ठरवा"

    field :heading_people, as: :heading, label: "उल्लेखित व्यक्ती"
    field :mentions, as: :has_many, name: "उल्लेख नोंदी", help: "व्यक्ती जोडण्यासाठी 'Attach' वापरा -- नवीन व्यक्ती आधी व्यक्ती विभागात तयार करा"
  end
end
