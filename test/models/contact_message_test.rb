require "test_helper"

class ContactMessageTest < ActiveSupport::TestCase
  test "Marathi validation messages read naturally" do
    message = ContactMessage.new
    message.valid?
    assert_includes message.errors[:name], "कृपया आपले नाव लिहा."
    assert_includes message.errors[:email], "कृपया आपला ईमेल पत्ता लिहा."
    assert_includes message.errors[:message], "कृपया आपला संदेश लिहा."
  end

  test "email must look like an email" do
    message = ContactMessage.new(name: "टेस्ट", email: "not-an-email", message: "..")
    assert_not message.valid?
    assert_includes message.errors[:email], "कृपया योग्य ईमेल पत्ता लिहा."
  end
end
