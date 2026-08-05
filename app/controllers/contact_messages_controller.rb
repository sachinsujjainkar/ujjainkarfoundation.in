# See prompts/phase-05-static-pages.md, संपर्क.
#
# hCaptcha isn't wired in -- no site/secret key is available in this
# environment, and a fabricated one would be worse than none. rack-attack
# (config/initializers/rack_attack.rb) throttles this endpoint in the
# meantime; add hCaptcha before this form is genuinely public.
class ContactMessagesController < ApplicationController
  def new
    @contact_message = ContactMessage.new
  end

  def create
    @contact_message = ContactMessage.new(contact_message_params)

    if @contact_message.save
      @submitted = true
      render :new
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def contact_message_params
    params.require(:contact_message).permit(:name, :email, :subject, :message)
  end
end
