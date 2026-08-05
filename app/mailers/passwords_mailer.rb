# Staff-only, like the rest of the auth system -- see SessionsController's
# comment. Locked to :mr, same reasoning as VolunteerMailer: admin mail is
# Marathi-only chrome, not bilingual site content.
class PasswordsMailer < ApplicationMailer
  def reset(user)
    @user = user
    # distance_of_time_in_words needs mr.datetime.distance_in_words.* --
    # deliberately not translated (see test/locale_completeness_test.rb's
    # comment on datetime.yml), so it prints "Translation missing" in
    # Marathi -- confirmed by actually rendering this email, not assumed.
    # A plain minute count in Devanagari numerals reads more natural here
    # anyway than a translated "X minutes" clause would.
    @expires_in_minutes = DevanagariNumerals.convert((user.password_reset_token_expires_in / 1.minute).to_i)
    I18n.with_locale(:mr) do
      mail subject: I18n.t("passwords_mailer.reset.subject"), to: user.email_address
    end
  end
end
