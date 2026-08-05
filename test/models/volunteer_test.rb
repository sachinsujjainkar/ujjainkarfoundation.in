require "test_helper"

class VolunteerTest < ActiveSupport::TestCase
  test "Marathi validation messages read naturally, not machine-translated" do
    volunteer = Volunteer.new
    volunteer.valid?
    assert_includes volunteer.errors[:name], "कृपया आपले नाव लिहा."
    assert_includes volunteer.errors[:phone], "कृपया आपला मोबाईल क्रमांक लिहा."
  end

  test "phone must be a valid 10-digit Indian mobile number" do
    volunteer = Volunteer.new(name: "टेस्ट", phone: "12345")
    assert_not volunteer.valid?
    assert_includes volunteer.errors[:phone], "कृपया योग्य १० अंकी मोबाईल क्रमांक लिहा."
  end

  test "defaults to status new" do
    volunteer = Volunteer.new(name: "टेस्ट", phone: "9876543210")
    volunteer.valid?
    assert_equal "new", volunteer.status
  end
end
