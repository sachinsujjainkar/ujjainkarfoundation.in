require "test_helper"

class MentionTest < ActiveSupport::TestCase
  test "the same person can only be mentioned once per article" do
    existing = mentions(:one)
    duplicate = Mention.new(article: existing.article, person: existing.person)

    assert_not duplicate.valid?
    assert_includes duplicate.errors[:person_id], "आधीच वापरले गेले आहे."
  end

  test "the same person can be mentioned in different articles" do
    mention = Mention.new(article: articles(:two), person: mentions(:one).person)
    assert mention.valid?
  end

  test "belongs to an article and a person" do
    assert_equal articles(:one), mentions(:one).article
    assert_equal people(:one), mentions(:one).person
  end
end
