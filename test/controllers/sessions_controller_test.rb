require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  setup { @user = User.take }

  test "new" do
    get new_session_path
    assert_response :success
  end

  test "create with valid credentials lands on the admin panel, not the public site" do
    post session_path, params: { email_address: @user.email_address, password: "password" }

    assert_redirected_to "/admin"
    assert cookies[:session_id]
  end

  test "create with invalid credentials" do
    post session_path, params: { email_address: @user.email_address, password: "wrong" }

    assert_redirected_to new_session_path
    assert_nil cookies[:session_id]
  end

  test "destroy" do
    sign_in_as(User.take)

    delete session_path

    assert_redirected_to new_session_path
    assert_empty cookies[:session_id]
  end

  test "create for an inactive user is refused even with the right password" do
    @user.update!(active: false)

    post session_path, params: { email_address: @user.email_address, password: "password" }

    assert_redirected_to new_session_path
    assert_nil cookies[:session_id]
  end

  # rack-attack's throttle uses Rails.cache, which is :null_store in the
  # test environment (config/environments/test.rb) -- swap in a real store
  # for just this test so the counter actually persists across requests.
  # This is an ActionDispatch::IntegrationTest (not a controller test), so
  # requests do go through the full middleware stack, Rack::Attack included.
  test "login is throttled by rack-attack after 5 attempts from the same IP" do
    original_store = Rack::Attack.cache.store
    Rack::Attack.cache.store = ActiveSupport::Cache::MemoryStore.new

    5.times { post session_path, params: { email_address: @user.email_address, password: "wrong" } }
    post session_path, params: { email_address: @user.email_address, password: "wrong" }

    assert_response :too_many_requests
  ensure
    Rack::Attack.cache.store = original_store
  end
end
