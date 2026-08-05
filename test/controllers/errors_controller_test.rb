require "test_helper"

class ErrorsControllerTest < ActionDispatch::IntegrationTest
  test "404 renders styled and bilingual, defaulting to Marathi" do
    get "/404"
    assert_response :not_found
    assert_select "h1", "पृष्ठ सापडले नाही"
    assert_select "a", "मुख्यपृष्ठावर परत जा"
  end

  test "404 honours an existing locale cookie" do
    cookies[:locale] = "en"
    get "/404"
    assert_response :not_found
    assert_select "h1", "Page not found"
  end

  test "500 renders styled and bilingual" do
    get "/500"
    assert_response :internal_server_error
    assert_select "h1", "काहीतरी चुकले"
  end

  # Not covered here: an actual unhandled routing/500 exception reaching
  # config.exceptions_app. test.rb sets consider_all_requests_local = true
  # (same as development), which makes Rails' own DebugExceptions
  # middleware show its interactive backtrace page instead of consulting
  # exceptions_app -- by design, for local debugging. Verified manually
  # instead, with consider_all_requests_local flipped to false (i.e.
  # production-like): an actual "/mr/bogus" routing failure does reach this
  # styled 404, not a static file or the debug page.

  test "site_setting falls back gracefully if SiteSetting is unavailable" do
    original_instance_method = SiteSetting.method(:instance)
    SiteSetting.define_singleton_method(:instance) { raise ActiveRecord::StatementInvalid, "connection lost" }

    get "/404"
    assert_response :not_found
  ensure
    # Restore, don't remove -- test.rb doesn't reload classes between tests
    # (config.enable_reloading = false), so a bare remove_method would
    # permanently delete SiteSetting.instance for the rest of the run.
    SiteSetting.define_singleton_method(:instance, original_instance_method)
  end
end
