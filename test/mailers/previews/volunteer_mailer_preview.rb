# Preview all emails at http://localhost:3000/rails/mailers/volunteer_mailer
class VolunteerMailerPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/volunteer_mailer/confirmation
  def confirmation
    volunteer = Volunteer.new(name: "रमेश पाटील", phone: "9876543210", email: "ramesh@example.com")
    VolunteerMailer.confirmation(volunteer)
  end
end
