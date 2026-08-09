require "test_helper"

class EventsControllerTest < ActionDispatch::IntegrationTest
  # events.yml's fixtures don't set title_mr -- Mobility-translated, no
  # fixture value there -- set here so assertions check real rendered
  # content, not two blanks matching by coincidence. Same pattern as
  # people_controller_test.rb.
  setup do
    events(:one).update!(title_mr: "आगामी चाचणी कार्यक्रम")
    events(:two).update!(title_mr: "झालेला चाचणी कार्यक्रम")
  end

  test "index lists upcoming published events, both locales" do
    get "/mr/karyakram"
    assert_response :success
    assert_select "a", text: "आगामी चाचणी कार्यक्रम"

    get "/en/events"
    assert_response :success
  end

  test "index lists past published events" do
    past = Event.create!(title_mr: "झालेला प्रकाशित कार्यक्रम", starts_at: 5.days.ago, published: true)
    get "/mr/karyakram"
    assert_select "h3", text: "झालेला प्रकाशित कार्यक्रम"
  ensure
    past&.destroy
  end

  test "index excludes unpublished events (fixture default)" do
    get "/mr/karyakram"
    assert_response :success
    assert_select "a", text: "झालेला चाचणी कार्यक्रम", count: 0
  end

  test "show renders a published event by slug" do
    get "/mr/karyakram/#{events(:one).slug}"
    assert_response :success
    assert_select "h1", text: "आगामी चाचणी कार्यक्रम"
  end

  test "show 404s for an unpublished event's slug" do
    get "/mr/karyakram/#{events(:two).slug}"
    assert_response :not_found
  end

  test "show 404s for an unknown slug" do
    get "/mr/karyakram/no-such-event"
    assert_response :not_found
  end

  # docs/04-routes.md's SEO requirements: "Event structured data on event pages."
  test "show carries valid Event structured data with the real start date" do
    get "/mr/karyakram/#{events(:one).slug}"

    json_ld = css_select("script[type='application/ld+json']").map { |node| JSON.parse(node.text) }
    event_schema = json_ld.find { |entry| entry["@type"] == "Event" }

    assert event_schema, "expected an Event JSON-LD block on the event page"
    assert_equal "आगामी चाचणी कार्यक्रम", event_schema["name"]
    assert_equal events(:one).starts_at.iso8601, event_schema["startDate"]
  end
end
