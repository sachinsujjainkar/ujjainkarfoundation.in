# Static pages -- not driven by the newsroom. See prompts/phase-05-static-pages.md.
class PagesController < ApplicationController
  def about
  end

  def committee
    @committees = Committee.includes(memberships: :person)
  end

  def donate
  end

  def transparency
  end

  def privacy
  end

  def terms
  end
end
