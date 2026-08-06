require "test_helper"

# Phase 11 -- the poster editor page itself. Rasterisation (html-to-image,
# document.fonts.ready, canvas export) only runs in a real browser and
# isn't exercised here; this covers what an integration test actually
# can: authentication/authorization on the route, the real prefill data
# reaching the page, and -- the one thing this whole feature exists to
# get right -- that Devanagari conjuncts survive the server-side pipeline
# into the HTML byte-for-byte, unmangled. See
# prompts/phase-11-poster-generator.md's "Watch for": "Verify conjunct
# rendering explicitly."
class PosterGeneratorTest < ActionDispatch::IntegrationTest
  setup do
    @admin = users(:one) # role: admin, per test/fixtures/users.yml
    @reporter = users(:two)
    @reporter.update!(role: :reporter)
    Current.session = @reporter.sessions.create!

    # A real conjunct-heavy headline -- ज्ञ (ज् + ञ) and क्ष (क् + ष) are
    # exactly the characters prompts/phase-11 names as the failure mode to
    # check for. If this string round-trips through the DB, the model,
    # the controller, and ERB unmangled, the server-side half of the
    # pipeline is sound; the browser's own text shaping (HarfBuzz) is the
    # remaining, unverifiable-here half.
    @article = Article.new(
      headline_mr: "क्षमायाचना: ज्ञानेश्वर मंदिर सोहळा", article_type: :statement, author: @reporter
    )
    @article.body = "मजकूर"
    @article.save!
    @article.submit!
    Current.session = @admin.sessions.create!
    @article.update!(status: :published)
  ensure
    Current.session = nil
  end

  test "an unauthenticated visitor is redirected to login" do
    get "/admin/posters/#{@article.id}"
    assert_redirected_to "/session/new"
  end

  test "signed-in staff can open the poster editor for a published article" do
    sign_in_as(@admin)

    get "/admin/posters/#{@article.id}"
    assert_response :success
  end

  test "the headline reaches the page with its conjuncts intact" do
    sign_in_as(@admin)

    get "/admin/posters/#{@article.id}"
    assert_match "क्षमायाचना: ज्ञानेश्वर मंदिर सोहळा", response.body
  end

  test "redirects to the articles list with an alert for an unpublished article" do
    draft = Article.new(headline_mr: "मसुदा बातमी", article_type: :statement, author: @reporter)
    draft.body = "मजकूर"
    Current.session = @reporter.sessions.create!
    draft.save!
    Current.session = nil
    sign_in_as(@admin)

    get "/admin/posters/#{draft.id}"
    assert_redirected_to "/admin/resources/articles"
  end

  test "redirects for a non-existent article id" do
    sign_in_as(@admin)

    get "/admin/posters/999999"
    assert_redirected_to "/admin/resources/articles"
  end

  test "the article's Avo show page offers the poster action once published" do
    sign_in_as(@admin)

    get "/admin/resources/articles/#{@article.id}"
    assert_response :success
    assert_match "पोस्टर तयार करा", response.body
  end

  test "the poster action is not offered for a draft article" do
    draft = Article.new(headline_mr: "मसुदा बातमी दोन", article_type: :statement, author: @reporter)
    draft.body = "मजकूर"
    Current.session = @reporter.sessions.create!
    draft.save!
    Current.session = nil
    sign_in_as(@admin)

    get "/admin/resources/articles/#{draft.id}"
    assert_response :success
    assert_no_match "पोस्टर तयार करा", response.body
  end
end
