require "test_helper"

class ActivitiesControllerTest < ActionDispatch::IntegrationTest
  test "index lists only published activities, both locales" do
    get "/mr/karyakshetre"
    assert_response :success
    assert_select "a[href=?]", "/mr/karyakshetre/#{activities(:one).slug}"
    assert_select "a[href=?]", "/mr/karyakshetre/#{activities(:two).slug}", count: 0

    get "/en/activities"
    assert_response :success
  end

  test "show renders a published activity by slug" do
    get "/mr/karyakshetre/#{activities(:one).slug}"
    assert_response :success
    assert_select "h1", text: activities(:one).name_mr
  end

  test "show 404s for an unpublished activity's slug" do
    get "/mr/karyakshetre/#{activities(:two).slug}"
    assert_response :not_found
  end

  test "show 404s for an unknown slug" do
    get "/mr/karyakshetre/no-such-activity"
    assert_response :not_found
  end
end
