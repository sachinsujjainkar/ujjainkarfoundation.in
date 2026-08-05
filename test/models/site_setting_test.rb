require "test_helper"

class SiteSettingTest < ActiveSupport::TestCase
  test "instance returns the existing row rather than creating a second one" do
    existing = site_settings(:current)
    assert_equal existing, SiteSetting.instance
    assert_equal 1, SiteSetting.count
  end

  test "instance creates a row with unconfirmed fields left blank when none exists yet" do
    SiteSetting.delete_all

    setting = SiteSetting.instance

    assert_predicate setting, :persisted?
    assert_nil setting.phone_primary
    assert_nil setting.email_public
    assert_equal false, setting.has_80g
  end

  test "a second row cannot be created" do
    assert_no_difference "SiteSetting.count" do
      second = SiteSetting.new(city: "दुसरे शहर")
      second.save
      assert_includes second.errors[:base], "only one SiteSetting may exist"
    end
  end
end
