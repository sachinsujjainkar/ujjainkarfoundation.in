require "test_helper"

class HomeControllerTest < ActionDispatch::IntegrationTest
  test "root returns 200" do
    get root_path
    assert_response :success
  end
end
