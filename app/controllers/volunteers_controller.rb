# See prompts/phase-05-static-pages.md, स्वयंसेवक.
#
# hCaptcha isn't wired in -- no site/secret key is available in this
# environment. rack-attack throttles this endpoint in the meantime; add
# hCaptcha before this form is genuinely public.
class VolunteersController < ApplicationController
  def new
    @volunteer = Volunteer.new
  end

  def create
    @volunteer = Volunteer.new(volunteer_params)

    if @volunteer.save
      VolunteerMailer.confirmation(@volunteer).deliver_later if @volunteer.email.present?
      @submitted = true
      render :new
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def volunteer_params
    params.require(:volunteer).permit(:name, :phone, :email, :taluka, :interest_area, :message)
  end
end
