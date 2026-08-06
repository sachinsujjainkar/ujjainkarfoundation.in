# बातम्या -- index (asymmetric editorial grid + type filter) and detail.
# See docs/03-data-model.md, Phase 09.
class ArticlesController < ApplicationController
  include Pagy::Backend

  def index
    scope = Article.published.includes(:activity, :author).order(published_at: :desc)
    scope = scope.where(article_type: params[:type]) if params[:type].present? && Article.article_types.key?(params[:type])
    @pagy, @articles = pagy(scope, limit: 12)
    @selected_type = params[:type]
  end

  # find_by! raises ActiveRecord::RecordNotFound on a bad/unpublished slug,
  # deliberately unrescued -- see ActivitiesController#show's identical
  # comment on why (config/application.rb's exceptions_app handles it).
  def show
    @article = Article.published.includes(:article_photos, :people, :activity, :author).find_by!(slug: params[:slug])
    @related = Article.published.where(activity_id: @article.activity_id).where.not(id: @article.id).limit(3) if @article.activity_id
    Article.where(id: @article.id).update_all("view_count = view_count + 1")
  end

  def search
    @query = params[:q].to_s.strip
    @results = @query.present? ? Article.search(@query).published : Article.none
  end

  def feed
    @articles = Article.published.order(published_at: :desc).limit(20)
    response.headers["Content-Type"] = "application/rss+xml"
  end
end
