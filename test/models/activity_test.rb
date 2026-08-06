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
    # Not Activity.destroy_all -- the activities fixture rows are now
    # referenced by the articles fixtures via a foreign key (Phase 09),
    # so wiping the whole table mid-test raises InvalidForeignKey. Scoped
    # to a fresh, high position range instead, and asserted by relative
    # order within that slice rather than exact table contents.
    third = Activity.create!(slug: "order-c", name_mr: "तिसरे", position: 903)
    first = Activity.create!(slug: "order-a", name_mr: "पहिले", position: 901)
    second = Activity.create!(slug: "order-b", name_mr: "दुसरे", position: 902)

    ordered = Activity.where(position: 901..903).to_a
    assert_equal [ first, second, third ], ordered
  end

  test "published scope only returns published activities" do
    published = Activity.create!(slug: "pub-scope-yes", name_mr: "प्रकाशित", published: true)
    unpublished = Activity.create!(slug: "pub-scope-no", name_mr: "अप्रकाशित", published: false)

    assert_includes Activity.published, published
    assert_not_includes Activity.published, unpublished
  end
end
