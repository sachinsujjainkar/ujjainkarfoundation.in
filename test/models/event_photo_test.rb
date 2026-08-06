require "test_helper"

class EventPhotoTest < ActiveSupport::TestCase
  test "includes Photoable -- image upload safety and named variants apply" do
    # .new -> .attach -> .save! in one flow, not attaching to an
    # already-persisted fixture record -- Photoable's safety check is
    # after_create_commit, which only fires on the record's own create,
    # not a later update. Same methodology as article_photo_test.rb.
    photo = EventPhoto.new(event: events(:one), credit: "चाचणी")
    photo.image.attach(
      io: File.open(file_fixture("test_photo.png")), filename: "test_photo.png", content_type: "image/png"
    )

    assert_enqueued_with(job: StripExifJob) { photo.save! }
  end

  test "credit has a length limit, per Photoable" do
    photo = event_photos(:one)
    photo.credit = "अ" * 201
    assert_not photo.valid?
    assert_includes photo.errors[:credit], "खूप मोठे आहे (जास्तीत जास्त 200 अक्षरे)."
  end

  test "belongs to an event" do
    assert_equal events(:one), event_photos(:one).event
  end
end
