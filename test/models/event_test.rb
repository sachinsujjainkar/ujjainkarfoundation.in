require "test_helper"

class EventTest < ActiveSupport::TestCase
  test "requires a Marathi title and a unique slug" do
    event = Event.new(slug: events(:one).slug)
    assert_not event.valid?
    assert_includes event.errors[:slug], "आधीच वापरले गेले आहे."
    assert_includes event.errors[:title_mr], "आवश्यक आहे."
  end

  test "auto-generates a transliterated slug from the Marathi title when none is given" do
    event = Event.create!(title_mr: "साहित्य संमेलन")
    assert_equal DevanagariTransliterator.call("साहित्य संमेलन"), event.slug
  end

  test "appends a numeric suffix on a slug collision" do
    Event.create!(slug: "karyakram-ek", title_mr: "कार्यक्रम एक")
    second = Event.create!(title_mr: "कार्यक्रम एक")
    assert_not_equal "karyakram-ek", second.slug
  end

  test "an explicit slug is not overwritten" do
    event = Event.create!(slug: "sthir-slug", title_mr: "स्थिर नाव")
    assert_equal "sthir-slug", event.slug
  end

  test "upcoming? is derived from starts_at, never stored" do
    future = Event.new(starts_at: 1.day.from_now)
    past = Event.new(starts_at: 1.day.ago)
    undated = Event.new(starts_at: nil)

    assert future.upcoming?
    assert_not past.upcoming?
    assert_not undated.upcoming?
  end

  test "upcoming scope only returns future-dated events, nearest first" do
    nearer = Event.create!(title_mr: "जवळचा", starts_at: 2.days.from_now)
    farther = Event.create!(title_mr: "दूरचा", starts_at: 10.days.from_now)

    upcoming = Event.where(id: [ nearer.id, farther.id ]).upcoming
    assert_equal [ nearer, farther ], upcoming.to_a
    assert_not_includes Event.upcoming, events(:two) # starts_at in the past
  end

  test "past scope only returns past-dated events, most recent first" do
    older = Event.create!(title_mr: "जुना", starts_at: 10.days.ago)
    newer = Event.create!(title_mr: "नवीन", starts_at: 2.days.ago)

    past = Event.where(id: [ older.id, newer.id ]).past
    assert_equal [ newer, older ], past.to_a
    assert_not_includes Event.past, events(:one) # starts_at in the future
  end

  test "published scope only returns published events" do
    assert_includes Event.published, events(:one)
    assert_not_includes Event.published, events(:two)
  end

  test "belongs to an activity, optionally" do
    event = Event.new(title_mr: "चाचणी", activity: nil)
    assert event.valid?
  end

  test "has_many articles, nullified on event destroy" do
    reporter = users(:one)
    reporter.update!(role: :reporter)
    Current.session = reporter.sessions.create!

    article = Article.new(headline_mr: "चाचणी बातमी", article_type: :event_report, author: reporter, event: events(:one))
    article.body = "मजकूर"
    article.save!

    assert_includes events(:one).articles, article
    events(:one).destroy
    assert_nil article.reload.event_id
  ensure
    Current.session = nil
  end

  test "hero_image goes through ImageUploadSafety -- content-type check and EXIF strip enqueued" do
    event = Event.new(title_mr: "चाचणी छायाचित्र कार्यक्रम")
    event.hero_image.attach(
      io: File.open(file_fixture("test_photo.png")), filename: "test_photo.png", content_type: "image/png"
    )

    assert_enqueued_with(job: StripExifJob) { event.save! }
  end
end
