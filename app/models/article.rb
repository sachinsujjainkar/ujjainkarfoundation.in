# बातम्या -- the centrepiece. See docs/03-data-model.md and
# docs/01-glossary.md ("Article types", "Workflow states", "Slug policy").
#
# `body` needs both Action Text (rich HTML) and per-locale storage, which
# Mobility's :table backend can't reach into (it stores translated columns,
# not associated rich-text records) -- so body_mr/body_en are two
# independent has_rich_text fields instead of going through `translates`,
# with a locale-aware `body` reader/writer mirroring the same en-falls-
# back-to-mr policy Mobility gives every other translated attribute here.
class Article < ApplicationRecord
  include ImageUploadSafety

  extend Mobility
  translates :headline, :subheadline, :seo_title, :meta_description, backend: :table

  has_rich_text :body_mr
  has_rich_text :body_en

  # बैठक वृत्त / पुरस्कार / निवड व नियुक्ती / कार्यक्रम वृत्त / निवेदन / उपक्रम वृत्त.
  # Explicit integer mapping, not enum's array-index default -- same
  # reasoning as User#role.
  enum :article_type, {
    meeting: 0, award: 1, appointment: 2, event_report: 3, statement: 4, initiative: 5
  }

  # मसुदा -> पुनरावलोकनासाठी -> प्रकाशित -> संग्रहित. See STATUS_TRANSITIONS
  # below for which moves are actually legal.
  enum :status, { draft: 0, submitted: 1, published: 2, archived: 3 }

  belongs_to :author, class_name: "User"
  belongs_to :published_by, class_name: "User", optional: true
  # event_id -> Event is Phase 10's addition; Event doesn't exist yet.
  belongs_to :activity, optional: true

  has_many :article_photos, -> { order(:position) }, dependent: :destroy
  has_many :mentions, dependent: :destroy
  has_many :people, through: :mentions

  # pg_trgm similarity search across headline_mr and body_mr --
  # prompts/phase-09-newsroom.md: "Postgres full-text dictionaries do not
  # support Marathi, so tsvector is not an option for Devanagari. Trigram
  # works well at this corpus size." Matches against body_mr's raw Action
  # Text HTML, not stripped plain text -- noisier than it would be
  # otherwise, but still finds real substring matches at the scale this
  # site runs at; revisit if that stops being true.
  #
  # :translations and :rich_text_body_mr are real associations Mobility
  # and Action Text generate automatically (confirmed via
  # Article.reflect_on_all_associations, not assumed from their docs).
  scope :search, ->(query) {
    return none if query.blank?

    # .select doesn't support :q-style bind params the way .where does --
    # connection.quote escapes the value once so it's safe to interpolate
    # directly into both the WHERE and the ranking SELECT expression.
    #
    # word_similarity(), not similarity()/the % operator -- confirmed by
    # actually running a search and getting zero results for a query that
    # obviously appeared in a real headline. similarity() scores the
    # WHOLE-STRING overlap, so a short query like "राखी" against a much
    # longer headline scores far below the 0.3 default threshold (0.17 in
    # the real case that surfaced this) even though it's an exact
    # substring match. word_similarity() finds the best-matching
    # word-boundary substring instead (scored 1.0 for the same case) --
    # the right comparison for "does this query appear in this text".
    quoted = connection.quote(query)

    left_joins(:translations, :rich_text_body_mr)
      .where(article_translations: { locale: "mr" })
      .where("word_similarity(#{quoted}, article_translations.headline) > 0.3 OR word_similarity(#{quoted}, action_text_rich_texts.body) > 0.3")
      .select("articles.*, GREATEST(word_similarity(#{quoted}, article_translations.headline), word_similarity(#{quoted}, action_text_rich_texts.body)) AS search_rank")
      .distinct
      .order("search_rank DESC")
  }

  has_one_attached :featured_image
  image_upload_safety :featured_image

  has_one_attached :notice_pdf
  validate :notice_pdf_is_a_reasonably_sized_pdf

  # "Marathi is required. English is optional -- that is editorial policy,
  # not an omission." docs/00-project-brief.md. Nothing else is a hard
  # requirement at the model level (dateline/type etc. matter editorially
  # but aren't enforced here) -- see prompts/phase-09-newsroom.md, task 2.
  validates :headline_mr, presence: true
  validates :body_mr, presence: true

  # draft -> submitted -> published -> archived, plus submitted -> draft
  # (send back for changes) -- not a free-for-all state machine gem, just
  # a small fixed table, same spirit as User's can_*? matrix.
  STATUS_TRANSITIONS = {
    "draft" => %w[submitted],
    "submitted" => %w[draft published],
    "published" => %w[archived],
    "archived" => %w[]
  }.freeze

  # Moving INTO these statuses is the "Publish / unpublish" row in
  # docs/00-project-brief.md's role matrix -- editor/admin only. Moving
  # into submitted/draft has no such gate: a reporter submits their own
  # work freely.
  GATED_STATUSES = %w[published archived].freeze

  before_validation :assign_author_from_current_user, on: :create
  # NOT NULL + unique on :slug (migration) needs *some* value at insert
  # time -- the real one needs the row's own id, which doesn't exist yet.
  # See finalize_slug! below.
  before_validation :assign_placeholder_slug, on: :create
  validate :status_transition_is_allowed, if: :status_changed?, on: :update
  validate :only_editor_or_admin_edits_others_work, on: :update

  after_create :finalize_slug!
  after_update_commit :notify_editors_on_submit, if: -> { saved_change_to_status?(from: "draft", to: "submitted") }
  after_update_commit :set_published_fields_and_notify_author, if: -> { saved_change_to_status?(to: "published") }

  def submit!
    update!(status: :submitted)
  end

  # Locale-aware, mirroring how Mobility's own `translates` attributes
  # fall back en -> mr (never the reverse) -- see docs/00-project-brief.md,
  # "Editorial policy." Can't use `translates` for body itself (see the
  # class comment), so this is written by hand instead.
  def body
    Mobility.locale.to_sym == :en && body_en.present? ? body_en : body_mr
  end

  def body=(value)
    if Mobility.locale.to_sym == :en
      self.body_en = value
    else
      self.body_mr = value
    end
  end

  private

  def assign_placeholder_slug
    self.slug ||= "pending-#{SecureRandom.hex(8)}"
  end

  def assign_author_from_current_user
    self.author ||= Current.user
  end

  # The real numeric-id-prefix slug can't be computed before the row
  # exists (Postgres assigns id at insert) -- before_validation sets a
  # throwaway unique placeholder so the NOT NULL/unique constraints are
  # satisfied at insert time, and this swaps in the real value
  # immediately after, via update_column so it doesn't re-trigger
  # validations/callbacks (it's part of the same create, not an edit).
  # Nobody outside this method ever sees the placeholder.
  def finalize_slug!
    base = DevanagariTransliterator.call(headline_mr)
    base = "batmi" if base.blank?
    update_column(:slug, "#{id}-#{base}")
  end

  def status_transition_is_allowed
    previous = status_was

    unless STATUS_TRANSITIONS.fetch(previous, []).include?(status)
      errors.add(:status, "#{previous} वरून #{status} मध्ये बदलता येत नाही")
      return
    end

    if GATED_STATUSES.include?(status) && Current.user && !Current.user.can_publish?
      errors.add(:status, "प्रकाशित/अप्रकाशित करण्याचा अधिकार फक्त संपादक व प्रशासकांना आहे")
    end
  end

  # Reporters edit only their own work; editors/admins edit anyone's --
  # docs/00-project-brief.md's role matrix, "Edit others'" row. No-ops
  # when there's no signed-in user in scope (seeds, non-request contexts).
  def only_editor_or_admin_edits_others_work
    return unless Current.user
    return if Current.user.can_edit_others_work?
    return if author_id == Current.user.id

    errors.add(:base, "इतरांनी लिहिलेल्या बातमीत बदल करण्याचा अधिकार नाही")
  end

  def notify_editors_on_submit
    ArticleMailer.submitted_for_review(self).deliver_later
  end

  def set_published_fields_and_notify_author
    update_columns(published_at: published_at || Time.current, published_by_id: published_by_id || Current.user&.id)
    ArticleMailer.published(self).deliver_later
  end

  def notice_pdf_is_a_reasonably_sized_pdf
    return unless notice_pdf.attached?

    errors.add(:notice_pdf, :too_large) if notice_pdf.blob.byte_size > 10.megabytes
    errors.add(:notice_pdf, "PDF फाईल असणे आवश्यक आहे") unless notice_pdf.blob.content_type == "application/pdf"
  end
end
