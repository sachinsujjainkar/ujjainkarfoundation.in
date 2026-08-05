class ApplicationMailer < ActionMailer::Base
  # No real SMTP is configured yet (docs/06-infrastructure.md names
  # Brevo/Resend for this) -- deliver_later queues via Solid Queue but
  # config/environments/production.rb has no smtp_settings block filled in.
  # ujjainkarfoundation.in is this project's own confirmed domain, not an
  # invented address.
  default from: ENV.fetch("MAIL_FROM_ADDRESS", "no-reply@ujjainkarfoundation.in")
  layout "mailer"
end
