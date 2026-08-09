# Pure Ruby (Builder::XmlMarkup), no ERB tags -- .xml.builder templates
# aren't ERB-processed at all, same lesson learned the hard way on
# feed.rss.builder (Phase 09).
xml.instruct! :xml, version: "1.0", encoding: "UTF-8"
xml.urlset "xmlns" => "http://www.sitemaps.org/schemas/sitemap/0.9",
  "xmlns:xhtml" => "http://www.w3.org/1999/xhtml" do
  @entries.each do |entry|
    # One <url> per locale -- Google's own sitemap guidance for hreflang
    # is a self-referencing entry per language version, each carrying the
    # full alternate set, not one entry with the other locale bolted on
    # as a footnote.
    %i[mr en].each do |locale|
      xml.url do
        xml.loc entry[locale]
        xml.lastmod entry[:lastmod].iso8601 if entry[:lastmod]
        xml.xhtml :link, rel: "alternate", hreflang: "mr", href: entry[:mr]
        xml.xhtml :link, rel: "alternate", hreflang: "en", href: entry[:en]
        xml.xhtml :link, rel: "alternate", hreflang: "x-default", href: entry[:mr]
      end
    end
  end
end
