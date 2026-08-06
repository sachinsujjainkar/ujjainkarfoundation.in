require "test_helper"

class ActivityTest < ActiveSupport::TestCase
  test "requires a Marathi name and a unique slug" do
    activity = Activity.new(slug: activities(:one).slug)
    assert_not activity.valid?
    assert_includes activity.errors[:slug], "आधीच वापरले गेले आहे."
    assert_includes activity.errors[:name_mr], "आवश्यक आहे."
  end

  test "icon_key must be one of the six known icons" do
    activity = Activity.new(slug: "chachani-tin", name_mr: "चाचणी", icon_key: "not-a-real-icon")
    assert_not activity.valid?

    activity.icon_key = "heart"
    assert activity.valid?
  end

  test "icon_key can be blank" do
    activity = Activity.new(slug: "chachani-char", name_mr: "चाचणी")
    assert activity.valid?
  end

  test "default_scope orders by position" do
    Activity.destroy_all
    third = Activity.create!(slug: "c", name_mr: "तिसरे", position: 3)
    first = Activity.create!(slug: "a", name_mr: "पहिले", position: 1)
    second = Activity.create!(slug: "b", name_mr: "दुसरे", position: 2)

    assert_equal [ first, second, third ], Activity.all.to_a
  end

  test "published scope only returns published activities" do
    Activity.destroy_all
    published = Activity.create!(slug: "p", name_mr: "प्रकाशित", published: true)
    Activity.create!(slug: "np", name_mr: "अप्रकाशित", published: false)

    assert_equal [ published ], Activity.published.to_a
  end
end
