require "test_helper"

class ArticleTest < ActiveSupport::TestCase
  # assert_enqueued_email_with -- ActionDispatch::IntegrationTest gets this
  # for free (see e.g. passwords_controller_test.rb), a plain
  # ActiveSupport::TestCase model test doesn't.
  include ActionMailer::TestHelper

  setup do
    @reporter = users(:one)
    @reporter.update!(role: :reporter)
    @editor = users(:two)
    @editor.update!(role: :editor)
  end

  teardown { Current.session = nil }

  def sign_in(user)
    Current.session = user.sessions.create!
  end

  def build_article(user, headline: "चाचणी बातमी", body: "मजकूर")
    article = Article.new(headline_mr: headline, article_type: :meeting, author: user)
    article.body = body
    article
  end

  test "requires headline_mr and body_mr; everything else optional" do
    article = Article.new(article_type: :meeting, author: @reporter)
    assert_not article.valid?
    assert_includes article.errors[:headline_mr], "आवश्यक आहे."
    assert_includes article.errors[:body_mr], "आवश्यक आहे."
  end

  test "slug is a numeric id prefix plus Latin transliteration, frozen after create" do
    sign_in(@reporter)
    article = build_article(@reporter, headline: "शिक्षण पुरस्कार वितरण")
    article.save!

    assert_equal "#{article.id}-shikshana-puraskaara-vitarana", article.slug

    original_slug = article.slug
    article.update!(headline_mr: "बदललेला मथळा")
    assert_equal original_slug, article.reload.slug
  end

  test "defaults to draft status and author is the current user when not given" do
    sign_in(@reporter)
    article = build_article(@reporter)
    article.author = nil
    article.save!

    assert article.draft?
    assert_equal @reporter, article.author
  end

  test "draft -> submitted is allowed for the author, any role" do
    sign_in(@reporter)
    article = build_article(@reporter)
    article.save!

    article.submit!
    assert article.submitted?
  end

  test "submitted -> published is blocked for a reporter, even the article's own author" do
    sign_in(@reporter)
    article = build_article(@reporter)
    article.save!
    article.submit!

    assert_not article.update(status: :published)
    assert_includes article.errors[:status], "प्रकाशित/अप्रकाशित करण्याचा अधिकार फक्त संपादक व प्रशासकांना आहे"
  end

  test "submitted -> published is allowed for an editor, and stamps published_at/published_by" do
    sign_in(@reporter)
    article = build_article(@reporter)
    article.save!
    article.submit!

    sign_in(@editor)
    travel_to Time.zone.parse("2026-08-06 10:00:00") do
      article.update!(status: :published)
    end

    assert article.published?
    assert_equal Time.zone.parse("2026-08-06 10:00:00"), article.published_at
    assert_equal @editor, article.published_by
  end

  test "draft -> published directly is not a legal transition, even for an editor" do
    sign_in(@editor)
    article = build_article(@editor)
    article.save!

    assert_not article.update(status: :published)
    assert_includes article.errors[:status], "draft वरून published मध्ये बदलता येत नाही"
  end

  test "published -> archived is allowed for an editor" do
    sign_in(@editor)
    article = build_article(@editor)
    article.save!
    article.update!(status: :submitted)
    article.update!(status: :published)

    article.update!(status: :archived)
    assert article.archived?
  end

  test "a reporter can edit their own draft" do
    sign_in(@reporter)
    article = build_article(@reporter)
    article.save!

    assert article.update(headline_mr: "सुधारित मथळा")
  end

  test "a reporter cannot edit someone else's article" do
    sign_in(@editor)
    article = build_article(@editor)
    article.save!

    sign_in(@reporter)
    assert_not article.update(headline_mr: "hacked")
    assert_includes article.errors[:base], "इतरांनी लिहिलेल्या बातमीत बदल करण्याचा अधिकार नाही"
  end

  test "an editor can edit a reporter's article" do
    sign_in(@reporter)
    article = build_article(@reporter)
    article.save!

    sign_in(@editor)
    assert article.update(headline_mr: "संपादकाने बदलले")
  end

  test "submitting notifies editors and admins by email" do
    sign_in(@reporter)
    article = build_article(@reporter)
    article.save!

    assert_enqueued_email_with ArticleMailer, :submitted_for_review, args: [ article ] do
      article.submit!
    end
  end

  test "publishing notifies the author by email" do
    sign_in(@reporter)
    article = build_article(@reporter)
    article.save!
    article.submit!

    sign_in(@editor)
    assert_enqueued_email_with ArticleMailer, :published, args: [ article ] do
      article.update!(status: :published)
    end
  end

  test "body falls back from English to Marathi, never the reverse" do
    sign_in(@reporter)
    article = build_article(@reporter, body: "मराठी मजकूर")
    article.save!

    Mobility.with_locale(:en) { assert_match "मराठी मजकूर", article.body.to_s }

    article.body_en = "English body"
    article.save!
    Mobility.with_locale(:en) { assert_match "English body", article.body.to_s }
    assert_match "मराठी मजकूर", article.body.to_s
  end
end
