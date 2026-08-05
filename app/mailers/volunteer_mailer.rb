class VolunteerMailer < ApplicationMailer
  def confirmation(volunteer)
    @volunteer = volunteer
    I18n.with_locale(:mr) do
      mail to: volunteer.email, subject: I18n.t("volunteer_mailer.confirmation.subject")
    end
  end
end
