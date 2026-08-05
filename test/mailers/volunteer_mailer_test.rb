require "test_helper"

class VolunteerMailerTest < ActionMailer::TestCase
  test "confirmation" do
    volunteer = Volunteer.create!(name: "रमेश पाटील", phone: "9876543210", email: "ramesh@example.com")
    mail = VolunteerMailer.confirmation(volunteer)

    assert_equal "स्वयंसेवक नोंदणीबद्दल धन्यवाद — शिवचरण उज्जैनकर फाउंडेशन", mail.subject
    assert_equal [ "ramesh@example.com" ], mail.to
    assert_equal [ "no-reply@ujjainkarfoundation.in" ], mail.from
    assert_match volunteer.name, mail.text_part.decoded
  end
end
