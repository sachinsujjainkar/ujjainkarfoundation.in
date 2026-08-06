# Staff-only, like PasswordsMailer -- locked to :mr, same reasoning
# (admin mail is Marathi-only chrome). prompts/phase-09-newsroom.md:
# "Email the editor on submit, the author on publish."
class ArticleMailer < ApplicationMailer
  # "The editor" isn't a single person in this app's model -- every
  # editor and admin gets it, since any of them can act on a submission.
  def submitted_for_review(article)
    @article = article
    recipients = User.where(role: %i[editor admin]).where(active: true).pluck(:email_address)
    return if recipients.empty?

    I18n.with_locale(:mr) do
      mail to: recipients, subject: I18n.t("article_mailer.submitted_for_review.subject", headline: article.headline_mr)
    end
  end

  def published(article)
    @article = article
    I18n.with_locale(:mr) do
      mail to: article.author.email_address, subject: I18n.t("article_mailer.published.subject", headline: article.headline_mr)
    end
  end
end
