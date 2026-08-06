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
end
