# /sitemap.xml -- prompts/phase-12-seo-launch.md: "both locales, hreflang
# alternates on every entry, regenerated on publish." "Regenerated on
# publish" here just means built fresh on every request (a plain read of
# already-published rows) rather than a separately-triggered background
# job -- the site's traffic doesn't come close to needing a cached one,
# and a stale cached sitemap is a worse failure mode than a slightly
# slower response.
class SitemapController < ApplicationController
  def index
    @entries = static_page_entries + activity_entries + article_entries + event_entries + person_entries + gallery_year_entries

    respond_to do |format|
      format.xml
    end
  end

  private

  # [name, mr_url, en_url, lastmod] for every entry -- the view just loops
  # this, no per-record-type branching there.
  def static_page_entries
    ([ :home ] + LocalizedPages::SEGMENTS.keys).map do |name|
      mr_url, en_url = if name == :home
        [ locale_root_url(locale: "mr"), locale_root_url(locale: "en") ]
      else
        [ send("mr_#{name}_url"), send("en_#{name}_url") ]
      end
      { mr: mr_url, en: en_url, lastmod: nil }
    end
  end

  def activity_entries
    Activity.published.map do |activity|
      { mr: mr_activities_detail_url(activity.slug), en: en_activities_detail_url(activity.slug), lastmod: activity.updated_at }
    end
  end

  def article_entries
    Article.published.map do |article|
      { mr: mr_articles_detail_url(article.slug), en: en_articles_detail_url(article.slug), lastmod: article.updated_at }
    end
  end

  def event_entries
    Event.published.map do |event|
      { mr: mr_events_detail_url(event.slug), en: en_events_detail_url(event.slug), lastmod: event.updated_at }
    end
  end

  # Anyone mentioned in a published article -- Person#articles is already
  # scoped through Mention (app/models/person.rb), but that association
  # doesn't itself filter to published articles, so this does the same
  # "has at least one real, public page worth indexing" check the person
  # page itself would show (test/controllers/people_controller_test.rb's
  # own real page, not a private/admin-only record).
  def person_entries
    Person.joins(:articles).where(articles: { status: Article.statuses.fetch(:published) }).distinct.map do |person|
      { mr: mr_person_detail_url(person.slug), en: en_person_detail_url(person.slug), lastmod: person.updated_at }
    end
  end

  def gallery_year_entries
    GalleryPhoto.years.map do |year|
      { mr: mr_gallery_year_url(year), en: en_gallery_year_url(year), lastmod: nil }
    end
  end
end
