require "test_helper"

class ArticlesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @reporter = users(:two)
    @reporter.update!(role: :reporter)
    Current.session = @reporter.sessions.create!

    @article = Article.new(headline_mr: "व्हिडिओसह चाचणी बातमी", article_type: :initiative, author: @reporter)
    @article.body = "मजकूर"
    @article.save!
    @article.submit!
    editor = users(:one)
    editor.update!(role: :editor)
    Current.session = editor.sessions.create!
    @article.update!(status: :published, youtube_id: "dQw4w9WgXcQ")
  end

  teardown { Current.session = nil }

  test "show embeds the YouTube facade when the article has a video" do
    get "/mr/batmya/#{@article.slug}"
    assert_response :success
    assert_select "[data-controller='youtube-embed'][data-youtube-embed-id-value='dQw4w9WgXcQ']"
  end

  test "show renders no video facade when the article has none" do
    @article.update!(youtube_id: nil)

    get "/mr/batmya/#{@article.slug}"
    assert_select "[data-controller='youtube-embed']", count: 0
  end
end
