# /feed.mr.xml, /feed.en.xml -- docs/04-routes.md. .builder templates are
# plain Ruby (the `xml` Builder::XmlMarkup object), not ERB -- no <% %>
# tags here. params[:locale] comes from the route default
# (config/routes.rb), not a request path segment, but
# ApplicationController#set_locale reads params[:locale] either way.
Mobility.with_locale(I18n.locale) do
  xml.instruct! :xml, version: "1.0"
  xml.rss version: "2.0", "xmlns:content" => "http://purl.org/rss/1.0/modules/content/" do
    xml.channel do
      xml.title site_name
      xml.description t("common.registered_trust_description")
      xml.link locale_root_url
      xml.language I18n.locale == :mr ? "mr-IN" : "en-IN"

      @articles.each do |article|
        # English feed, article with no English content -- skip rather
        # than show blank or Marathi-fallback text in an RSS reader that
        # requested the English feed specifically.
        next if article.headline.blank?

        xml.item do
          xml.title article.headline
          xml.description article.subheadline.presence || strip_tags(article.body.to_s).truncate(300)
          xml.pubDate article.published_at.rfc822
          xml.link localized_detail_url(:articles, article.slug)
          xml.guid localized_detail_url(:articles, article.slug)
          xml.author article.author.name
        end
      end
    end
  end
end
