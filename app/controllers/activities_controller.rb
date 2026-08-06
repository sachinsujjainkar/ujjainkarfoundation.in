# कार्यक्षेत्रे -- index and detail. See docs/03-data-model.md, Phase 08.
class ActivitiesController < ApplicationController
  def index
    @activities = Activity.published
  end

  # find_by! raises ActiveRecord::RecordNotFound on a bad/unpublished slug --
  # deliberately not rescued here. config/application.rb's exceptions_app
  # (ErrorsController) already handles that globally for every controller;
  # catching it locally would just bypass that and diverge from how the
  # rest of the app does 404s.
  def show
    @activity = Activity.published.find_by!(slug: params[:slug])
  end
end
