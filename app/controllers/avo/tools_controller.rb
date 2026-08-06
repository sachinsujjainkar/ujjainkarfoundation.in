# prompts/phase-07-admin-auth.md: "Custom dashboard: pending review count,
# drafts, recent published, unread messages, new volunteers."
#
# Not built on Avo's own Dashboard/MetricCard DSL -- confirmed by actually
# generating a dashboard (`bin/rails generate avo:dashboard`), checking
# `bin/rails routes`, and reading avo/home_controller.rb: Avo community has
# the Dashboard/Card classes (so the generator runs without error), but no
# controller or route ever renders one -- `config.home_path` can only
# redirect to a resource or a custom Tool page. Community "Dashboards" in
# Avo's marketing material turned out to mean something else than a
# routable page in this edition. A custom Tool (also generated, confirmed
# to get a real route) is the actual supported way to build this in
# community Avo, so that's what this is.
#
# All five counts are real as of Phase 09 -- the first three were an
# honest zero placeholder ("newsroom doesn't exist yet") until Article
# landed.
class Avo::ToolsController < Avo::ApplicationController
  # Avo's own views don't pull in the app's app/helpers/* the way the
  # public ApplicationController's views do (confirmed by actually hitting
  # this page and getting a real NoMethodError on `dateline` from
  # avo/tools/poster.html.erb) -- included explicitly here and called from
  # the action instead, same shape as this controller's existing use of
  # DevanagariNumerals (a plain class, not a helper) in dashboard.html.erb.
  include DateFormattingHelper

  def dashboard
    @page_title = "डॅशबोर्ड"
    add_breadcrumb "डॅशबोर्ड"

    @pending_review_count = Article.submitted.count
    @drafts_count = Article.draft.count
    @recently_published_count = Article.published.where(published_at: 7.days.ago..).count
    @unread_messages_count = ContactMessage.where(read: false).count
    @new_volunteers_count = Volunteer.where(status: Volunteer::STATUSES.first).count
  end

  # पोस्टर generator -- prompts/phase-11-poster-generator.md, task 3:
  # "an admin button on any published article pre-fills headline, date,
  # featured photo, and logo into the chosen template." Marathi-only, not
  # locale-switched like the public site -- posters are for WhatsApp
  # circulation among a Marathi-speaking audience, and the whole point of
  # this tool is staff who work in Marathi on WhatsApp, not a bilingual
  # workflow (prompts/phase-11, and the user's own framing: "the NGO ppls
  # are not techy... doing it on WA").
  def poster
    @article = Article.published.find(params[:article_id])
    @page_title = "पोस्टर तयार करा"
    add_breadcrumb "पोस्टर तयार करा"

    Mobility.with_locale(:mr) do
      @headline = @article.headline
    end
    @dateline = dateline(@article.dateline_place, @article.published_at)
  rescue ActiveRecord::RecordNotFound
    # A raw path, not a resources_articles_path helper -- same convention
    # as config/initializers/avo.rb's authenticate_with redirects, since
    # Avo's root_path is configurable (currently "/admin") rather than
    # assumed fixed.
    redirect_to "#{Avo.configuration.root_path}/resources/articles", alert: "ही बातमी सापडली नाही किंवा अद्याप प्रकाशित नाही."
  end
end
