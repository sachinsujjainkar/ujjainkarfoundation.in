require "test_helper"

class PersonTest < ActiveSupport::TestCase
  test "slug is generated from the Marathi name on create, transliterated to Latin" do
    person = Person.create!(name_mr: "रमेश पाटील")
    assert_equal "ramesha-paatiila", person.slug
  end

  test "slug collisions get a numeric suffix" do
    Person.create!(name_mr: "सुनील शर्मा")
    second = Person.create!(name_mr: "सुनील शर्मा")
    assert_match(/-2\z/, second.slug)
  end

  test "requires a Marathi name, with a natural Marathi message" do
    person = Person.new
    assert_not person.valid?
    assert_includes person.errors[:name_mr], "कृपया व्यक्तीचे नाव लिहा."
  end

  # ImageUploadSafety (app/models/concerns/image_upload_safety.rb) --
  # docs/03-data-model.md's `has_one_attached :photo`. See Photoable's own
  # header comment for why the actual EXIF-strip/variant *processing* isn't
  # exercised here (no libvips in this environment) -- these tests only
  # confirm the record-level contract: what gets enqueued and what gets
  # rejected, both of which the :test queue adapter can verify without
  # ever running a job.
  test "accepts a real photo and enqueues EXIF stripping after create" do
    person = Person.new(name_mr: "आरती देशमुख")
    person.photo.attach(
      io: File.open(file_fixture("test_photo.png")), filename: "test_photo.png", content_type: "image/png"
    )

    assert_enqueued_with(job: StripExifJob) { person.save! }
  end

  test "rejects a photo larger than 10MB" do
    person = Person.new(name_mr: "आरती देशमुख")
    oversized = StringIO.new(File.binread(file_fixture("test_photo.png")) + ("a" * 11.megabytes))
    person.photo.attach(io: oversized, filename: "big.png", content_type: "image/png")

    assert_not person.valid?
    assert_includes person.errors[:photo], "छायाचित्राचा आकार १० MB पेक्षा जास्त आहे. कृपया लहान आकाराचे छायाचित्र अपलोड करा."
  end

  test "purges a photo whose real bytes don't match its declared content type" do
    person = Person.new(name_mr: "आरती देशमुख")
    person.photo.attach(
      io: StringIO.new("not actually an image"), filename: "fake.png", content_type: "image/png"
    )

    assert_enqueued_with(job: ActiveStorage::PurgeJob) { person.save! }
  end
end
