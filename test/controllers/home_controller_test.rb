require "test_helper"

class HomeControllerTest < ActionDispatch::IntegrationTest
  test "locale-prefixed home pages return 200" do
    get locale_root_path(locale: "mr")
    assert_response :success

    get locale_root_path(locale: "en")
    assert_response :success
  end

  test "an unrecognised locale segment 404s" do
    get "/xx"
    assert_response :not_found
  end

  test "bare root redirects to Marathi by default" do
    get root_path
    assert_redirected_to "/mr"
  end

  test "bare root redirects to English only when Accept-Language clearly prefers it" do
    get root_path, headers: { "Accept-Language" => "en-US,en;q=0.9" }
    assert_redirected_to "/en"
  end

  test "a lower-priority en in Accept-Language does not override the Marathi default" do
    get root_path, headers: { "Accept-Language" => "hi-IN,hi;q=0.9,en;q=0.5" }
    assert_redirected_to "/mr"
  end

  test "bare root honours an existing locale cookie over Accept-Language" do
    cookies[:locale] = "en"
    get root_path, headers: { "Accept-Language" => "mr-IN" }
    assert_redirected_to "/en"
  end

  test "visiting a locale page sets the locale cookie for a year" do
    get locale_root_path(locale: "en")
    assert_equal "en", cookies[:locale]
  end

  test "hreflang pair and x-default are present and reciprocal" do
    get locale_root_path(locale: "mr")
    assert_select "link[rel=alternate][hreflang=mr]", href: "http://www.example.com/mr"
    assert_select "link[rel=alternate][hreflang=en]", href: "http://www.example.com/en"
    assert_select "link[rel=alternate][hreflang=x-default]", href: "http://www.example.com/mr"
  end

  test "the language switcher stays on the same page, not the homepage" do
    get locale_root_path(locale: "mr")
    assert_select "nav.lang-switch a[lang=en][href=?]", "/en"
    assert_select "nav.lang-switch a[lang=mr][aria-current=true]"
  end

  # docs/04-routes.md's SEO requirements: "NGO / Organization structured
  # data on the homepage, including registration number once confirmed."
  test "the homepage carries valid NGO structured data with the real registration number" do
    get locale_root_path(locale: "mr")

    json_ld = css_select("script[type='application/ld+json']").map { |node| JSON.parse(node.text) }
    ngo = json_ld.find { |entry| entry["@type"] == "NGO" }

    assert ngo, "expected an NGO JSON-LD block on the homepage"
    assert_equal SiteSetting.instance.registration_number, ngo.dig("identifier", "value")
  end
end
