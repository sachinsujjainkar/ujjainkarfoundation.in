require "test_helper"
require "rexml/document"

class SitemapControllerTest < ActionDispatch::IntegrationTest
  test "renders valid XML with both locales for every static page" do
    get "/sitemap.xml"
    assert_response :success
    assert_equal "application/xml", response.media_type

    doc = REXML::Document.new(response.body)
    assert_equal "urlset", doc.root.name

    locs = REXML::XPath.match(doc, "//loc").map(&:text)
    assert_includes locs, "http://www.example.com/mr"
    assert_includes locs, "http://www.example.com/en"
    assert_includes locs, "http://www.example.com/mr/aamchyavishayi"
    assert_includes locs, "http://www.example.com/en/about"
  end

  test "includes a published article, excludes a draft one" do
    reporter = users(:two)
    reporter.update!(role: :reporter)
    Current.session = reporter.sessions.create!

    published = Article.new(headline_mr: "साइटमॅप चाचणी प्रकाशित", article_type: :statement, author: reporter)
    published.body = "मजकूर"
    published.save!
    published.submit!
    editor = users(:one)
    editor.update!(role: :editor)
    Current.session = editor.sessions.create!
    published.update!(status: :published)

    draft = Article.new(headline_mr: "साइटमॅप चाचणी मसुदा", article_type: :statement, author: reporter)
    draft.body = "मजकूर"
    draft.save!

    get "/sitemap.xml"
    locs = REXML::XPath.match(REXML::Document.new(response.body), "//loc").map(&:text)

    assert_includes locs, "http://www.example.com/mr/batmya/#{published.slug}"
    assert_not_includes locs, "http://www.example.com/mr/batmya/#{draft.slug}"
  ensure
    Current.session = nil
  end

  test "every url entry carries a reciprocal hreflang pair" do
    get "/sitemap.xml"
    doc = REXML::Document.new(response.body)

    REXML::XPath.match(doc, "//url").each do |url|
      hreflangs = REXML::XPath.match(url, "xhtml:link").map { |link| link.attribute("hreflang").value }
      assert_includes hreflangs, "mr"
      assert_includes hreflangs, "en"
      assert_includes hreflangs, "x-default"
    end
  end
end
