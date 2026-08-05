require "test_helper"

# Real enforcement, not just the can_*? methods being correct in isolation
# -- config/initializers/avo.rb's authenticate_with block is where role
# scoping actually happens (Avo community has no per-resource authorization
# of its own; see that file's comment). Hits the real mounted Avo routes.
class AvoAuthorizationTest < ActionDispatch::IntegrationTest
  setup do
    @admin = users(:one) # role: admin, per test/fixtures/users.yml
    @reporter = users(:two) # role: reporter
  end

  test "an unauthenticated visitor is redirected to the login page" do
    get "/admin"
    assert_redirected_to "/session/new"
  end

  test "an inactive user's session is refused even though the cookie is valid" do
    @admin.update!(active: false)
    sign_in_as(@admin)

    get "/admin"
    assert_redirected_to "/session/new"
  end

  test "admin can reach the users resource" do
    sign_in_as(@admin)

    get "/admin/resources/users"
    assert_response :success
  end

  test "reporter is refused the users resource, admin-only" do
    sign_in_as(@reporter)

    get "/admin/resources/users"
    assert_redirected_to "/admin"
  end

  test "reporter is refused the site_settings resource, admin-only" do
    sign_in_as(@reporter)

    get "/admin/resources/site_settings"
    assert_redirected_to "/admin"
  end

  test "admin can reach the site_settings resource" do
    sign_in_as(@admin)

    get "/admin/resources/site_settings"
    assert_response :success
  end

  test "reporter cannot delete a record, admin-only action" do
    sign_in_as(@reporter)

    assert_no_difference -> { Volunteer.count } do
      delete "/admin/resources/volunteers/#{volunteers(:one).id}"
    end
    assert_redirected_to "/admin"
  end

  test "admin can delete a record" do
    sign_in_as(@admin)

    assert_difference -> { Volunteer.count }, -1 do
      delete "/admin/resources/volunteers/#{volunteers(:one).id}"
    end
  end

  test "reporter can still reach an ordinary resource" do
    sign_in_as(@reporter)

    get "/admin/resources/volunteers"
    assert_response :success
  end

  test "the custom dashboard tool requires authentication too" do
    get "/admin/dashboard"
    assert_redirected_to "/session/new"
  end

  test "the dashboard shows real counts for messages and volunteers" do
    ContactMessage.create!(name: "चाचणी", email: "test@example.com", message: "चाचणी संदेश", read: false)
    Volunteer.create!(name: "चाचणी", phone: "9876543210", status: "new")
    sign_in_as(@admin)

    get "/admin/dashboard"
    assert_response :success
    assert_match "न वाचलेले संदेश", response.body
    assert_match "नवीन स्वयंसेवक", response.body
  end

  # prompts/phase-07-admin-auth.md: "no public registration route exists."
  # Checks the actual route set, not just "nobody wired up a controller
  # action" -- Avo's own users#create (Avo::UsersController, admin-only,
  # gated above) is a DIFFERENT, legitimate route and must not trip this.
  test "no public user registration route exists in the top-level route set" do
    top_level_controllers = Rails.application.routes.routes.map { |r| r.defaults[:controller] }.compact

    assert_not_includes top_level_controllers, "users",
      "found a top-level (non-Avo) users controller route -- that would be public self-registration"
  end
end
