# Static pages -- not driven by the newsroom. See prompts/phase-05-static-pages.md.
class PagesController < ApplicationController
  # Looked up by name, not a dedicated is_founder flag -- same pattern
  # db/seeds.rb already uses for people tagged in articles (Person has no
  # "role" concept beyond Membership's, and one more boolean column for a
  # single record didn't seem worth it). name_mr is Mobility-translated,
  # not a real column, so this is a plain Ruby scan rather than a WHERE
  # clause -- Person count is small. Nil-safe in the view for any
  # environment where seeds haven't run.
  FOUNDER_NAME_MR = "शिवचरण मधुकर उज्जैनकर"

  def about
    @founder = Person.all.find { |p| p.name_mr == FOUNDER_NAME_MR }
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
