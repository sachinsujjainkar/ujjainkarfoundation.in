require "test_helper"

class GalleryPhotoTest < ActiveSupport::TestCase
  test "combines photos from published articles and published events" do
    reporter = users(:one)
    reporter.update!(role: :reporter)
    Current.session = reporter.sessions.create!

    article = Article.new(headline_mr: "छायाचित्र बातमी", article_type: :initiative, author: reporter)
    article.body = "मजकूर"
    article.save!
    article.submit!
    editor = users(:two)
    editor.update!(role: :editor)
    Current.session = editor.sessions.create!
    article.update!(status: :published)

    article_photo = ArticlePhoto.new(article: article)
    article_photo.image.attach(io: File.open(file_fixture("test_photo.png")), filename: "a.png", content_type: "image/png")
    article_photo.save!

    events(:one).update!(title_mr: "छायाचित्र कार्यक्रम", published: true)
    event_photo = EventPhoto.new(event: events(:one))
    event_photo.image.attach(io: File.open(file_fixture("test_photo.png")), filename: "b.png", content_type: "image/png")
    event_photo.save!

    _pagy, photos = GalleryPhoto.page
    assert_includes photos, article_photo
    assert_includes photos, event_photo
  ensure
    Current.session = nil
  end

  test "excludes photos from unpublished parents" do
    photo = EventPhoto.new(event: events(:two)) # unpublished by fixture default
    photo.image.attach(io: File.open(file_fixture("test_photo.png")), filename: "c.png", content_type: "image/png")
    photo.save!

    _pagy, photos = GalleryPhoto.page
    assert_not_includes photos, photo
  end

  test "filters by activity_id" do
    events(:one).update!(title_mr: "कार्यक्षेत्र चाचणी", published: true, activity: activities(:one))
    photo_one = EventPhoto.new(event: events(:one))
    photo_one.image.attach(io: File.open(file_fixture("test_photo.png")), filename: "d.png", content_type: "image/png")
    photo_one.save!

    other_event = Event.create!(title_mr: "इतर कार्यक्षेत्र", published: true, activity: nil)
    photo_other = EventPhoto.new(event: other_event)
    photo_other.image.attach(io: File.open(file_fixture("test_photo.png")), filename: "e.png", content_type: "image/png")
    photo_other.save!

    _pagy, photos = GalleryPhoto.page(activity_id: activities(:one).id)
    assert_includes photos, photo_one
    assert_not_includes photos, photo_other
  end

  test "filters by year" do
    events(:one).update!(title_mr: "वर्ष चाचणी", published: true, starts_at: Time.zone.local(2022, 6, 1))
    photo = EventPhoto.new(event: events(:one))
    photo.image.attach(io: File.open(file_fixture("test_photo.png")), filename: "f.png", content_type: "image/png")
    photo.save!

    _pagy, matching = GalleryPhoto.page(year: 2022)
    _pagy, non_matching = GalleryPhoto.page(year: 1999)
    assert_includes matching, photo
    assert_not_includes non_matching, photo
  end

  test "years returns distinct years present in the combined feed" do
    events(:one).update!(title_mr: "वितरण वर्ष चाचणी", published: true, starts_at: Time.zone.local(2021, 1, 1))
    photo = EventPhoto.new(event: events(:one))
    photo.image.attach(io: File.open(file_fixture("test_photo.png")), filename: "g.png", content_type: "image/png")
    photo.save!

    assert_includes GalleryPhoto.years, 2021
  end
end
