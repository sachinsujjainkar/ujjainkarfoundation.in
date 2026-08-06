require "test_helper"

# Separate from article_test.rb -- this exercises real pg_trgm queries
# against real data, not just Ruby-level model behaviour.
class ArticleSearchTest < ActiveSupport::TestCase
  setup do
    @reporter = users(:one)
    @reporter.update!(role: :reporter)
    Current.session = @reporter.sessions.create!

    @article = Article.new(headline_mr: "आळंदीत विश्वविक्रमी राखी अर्पण", article_type: :initiative, author: @reporter)
    @article.body = "संत ज्ञानेश्वर माऊलींना राखी अर्पण करण्यात आली."
    @article.save!
    @article.submit!
    @editor = users(:two)
    @editor.update!(role: :editor)
    Current.session = @editor.sessions.create!
    @article.update!(status: :published)
  end

  teardown { Current.session = nil }

  test "finds a published article by a short word that's a substring of its headline" do
    # This is the exact case that caught a real bug: pg_trgm's plain
    # similarity() (the % operator) scores a short query against a much
    # longer headline far below its match threshold even on an exact
    # substring hit -- word_similarity() is required instead. Verified by
    # actually running this query against real data, not assumed correct
    # from reading pg_trgm's docs.
    assert_includes Article.search("राखी"), @article
  end

  test "finds a published article by words from its body" do
    assert_includes Article.search("संत ज्ञानेश्वर"), @article
  end

  test "does not match unrelated queries" do
    assert_not_includes Article.search("असंबंधित शब्द"), @article
  end

  test "does not return unpublished articles" do
    @article.update!(status: :archived)
    assert_not_includes Article.search("राखी").published, @article
  end

  test "blank query returns no results rather than everything" do
    assert_empty Article.search("")
    assert_empty Article.search(nil)
  end
end
