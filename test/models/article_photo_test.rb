require "test_helper"

class ArticlePhotoTest < ActiveSupport::TestCase
  test "includes Photoable -- image upload safety and named variants apply" do
    # .new -> .attach -> .save! in one flow, not attaching to an
    # already-persisted fixture record -- Photoable's safety check is
    # after_create_commit, which only fires on the record's own create,
    # not a later update. Same methodology mistake caught (and documented)
    # for Person#photo earlier in this project; applies identically here.
    photo = ArticlePhoto.new(article: articles(:one), credit: "चाचणी")
    photo.image.attach(
      io: File.open(file_fixture("test_photo.png")), filename: "test_photo.png", content_type: "image/png"
    )

    assert_enqueued_with(job: StripExifJob) { photo.save! }
  end

  test "credit has a length limit, per Photoable" do
    photo = article_photos(:one)
    photo.credit = "अ" * 201
    assert_not photo.valid?
    assert_includes photo.errors[:credit], "खूप मोठे आहे (जास्तीत जास्त 200 अक्षरे)."
  end

  test "belongs to an article" do
    assert_equal articles(:one), article_photos(:one).article
  end
end
