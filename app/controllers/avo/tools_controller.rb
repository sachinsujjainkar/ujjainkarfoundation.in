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
  def dashboard
    @page_title = "डॅशबोर्ड"
    add_breadcrumb "डॅशबोर्ड"

    @pending_review_count = Article.submitted.count
    @drafts_count = Article.draft.count
    @recently_published_count = Article.published.where(published_at: 7.days.ago..).count
    @unread_messages_count = ContactMessage.where(read: false).count
    @new_volunteers_count = Volunteer.where(status: Volunteer::STATUSES.first).count
  end
end
