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
end
