require "test_helper"

class ApplicationHelperTest < ActionView::TestCase
  test "flash_type maps Rails' own keys and this app's onto the three flash variants" do
    assert_equal :success, flash_type(:notice)
    assert_equal :success, flash_type("success")
    assert_equal :warn, flash_type(:warning)
    assert_equal :danger, flash_type(:alert)
    assert_equal :danger, flash_type("error")
  end

  test "flash_type defaults to :success for an unrecognised key" do
    assert_equal :success, flash_type(:something_unexpected)
  end
end
