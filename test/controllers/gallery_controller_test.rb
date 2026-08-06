require "test_helper"

class GalleryControllerTest < ActionDispatch::IntegrationTest
  test "photos tab renders successfully with no photos yet" do
    get "/mr/dalan"
    assert_response :success
  end

  test "photos tab shows a photo from a published event" do
    events(:one).update!(title_mr: "छायाचित्र कार्यक्रम")
    photo = EventPhoto.new(event: events(:one))
    photo.image.attach(
      io: File.open(file_fixture("test_photo.png")), filename: "test_photo.png", content_type: "image/png"
    )
    photo.save!

    get "/mr/dalan"
    assert_response :success
    assert_select "[data-lightbox-target=item]", count: 1
  end

  test "photos tab excludes photos belonging to an unpublished event" do
    photo = EventPhoto.new(event: events(:two)) # events(:two) is unpublished
    photo.image.attach(
      io: File.open(file_fixture("test_photo.png")), filename: "test_photo.png", content_type: "image/png"
    )
    photo.save!

    get "/mr/dalan"
    assert_select "[data-lightbox-target=item]", count: 0
  end

  test "year archive route filters to that year only" do
    events(:one).update!(title_mr: "वर्ष चाचणी", starts_at: Time.zone.local(2024, 3, 1))
    photo = EventPhoto.new(event: events(:one))
    photo.image.attach(
      io: File.open(file_fixture("test_photo.png")), filename: "test_photo.png", content_type: "image/png"
    )
    photo.save!

    get "/mr/dalan/2024"
    assert_select "[data-lightbox-target=item]", count: 1

    get "/mr/dalan/2019"
    assert_select "[data-lightbox-target=item]", count: 0
  end

  test "videos tab lists published events with a youtube_id" do
    events(:one).update!(title_mr: "चित्रफीत कार्यक्रम", youtube_id: "dQw4w9WgXcQ")
    get "/mr/dalan?tab=videos"
    assert_response :success
    assert_select "a", text: "चित्रफीत कार्यक्रम"
  end

  test "videos tab excludes events without a youtube_id" do
    events(:one).update!(title_mr: "चित्रफीतशिवाय", youtube_id: nil)
    get "/mr/dalan?tab=videos"
    assert_select "a", text: "चित्रफीतशिवाय", count: 0
  end

  test "en locale uses the /gallery segment" do
    get "/en/gallery"
    assert_response :success
  end
end
