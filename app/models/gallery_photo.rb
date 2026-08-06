# Read-only assembly of ArticlePhoto + EventPhoto into one feed -- the "no
# Album model" instruction from prompts/phase-10-events-gallery.md ("The
# gallery assembles itself from existing ArticlePhoto and EventPhoto
# records, grouped by कार्यक्षेत्र and by year. One upload point, two
# display surfaces, nothing maintained twice.").
#
# Not an ActiveRecord-backed table -- a thin wrapper around a raw SQL UNION
# so filtering and pagination happen at the query level even at gallery
# scale, per that same file's "Watch for": "The gallery can grow to
# thousands of images. Paginate at the query level, do not load all IDs."
# GalleryController never loads the full photo set into memory to filter
# or count it in Ruby.
#
# activity_id/year/page/per_page ultimately come from request params
# (GalleryController), so every value that reaches raw SQL here goes
# through sanitize_sql_array's real bind parameters -- never plain string
# interpolation of anything request-derived.
class GalleryPhoto
  PER_PAGE = 24

  # sort_date columns (articles.published_at / events.starts_at) are
  # `timestamp without time zone`, and Rails stores them as UTC clock time
  # (config.time_zone is "Mumbai" -- IST, UTC+5:30) -- see config/application.rb.
  # Plain EXTRACT(YEAR FROM sort_date) reads that raw UTC value, so an
  # event at, say, IST 2am on 1 Jan is stored as UTC ~8:30pm on 31 Dec and
  # would misfile into the previous year's archive. Caught by actually
  # asserting on a midnight-adjacent date in gallery_photo_test.rb, not
  # assumed from reading the column type. Interpret as UTC, then convert
  # to the app's real zone, before extracting the year.
  LOCAL_YEAR_SQL = "EXTRACT(YEAR FROM sort_date AT TIME ZONE 'UTC' AT TIME ZONE 'Asia/Kolkata')"

  # Only published/publicly-visible parents feed the gallery -- a draft
  # article's press photos aren't public yet just because the photo row
  # itself has no visibility flag of its own. :published_status is
  # Article's own enum mapping, not request-derived, but goes through the
  # same bind mechanism as everything else here rather than being a
  # special case.
  #
  # Also requires a real active_storage_attachments row for the `image`
  # attachment -- a photo record can exist without one ever actually being
  # attached (an admin-created row mid-upload, a stray fixture). Caught by
  # actually running a controller test against fixture data: event_photos(:one)
  # has no image attached, so its parent event being published was enough
  # to put a nil-image row into the feed, and `photo.image.variant(...)`
  # on that row returns nil -- which url_for then can't route, silently
  # regenerating the CURRENT page's URL and raising a confusing
  # "no route matches" error nowhere near the real cause.
  UNION_SQL = <<~SQL.freeze
    SELECT 'ArticlePhoto' AS photoable_type, article_photos.id AS photoable_id,
           articles.published_at AS sort_date, articles.activity_id AS activity_id
      FROM article_photos
      INNER JOIN articles ON articles.id = article_photos.article_id
      INNER JOIN active_storage_attachments ON active_storage_attachments.record_type = 'ArticlePhoto'
        AND active_storage_attachments.record_id = article_photos.id
        AND active_storage_attachments.name = 'image'
     WHERE articles.status = :published_status
    UNION ALL
    SELECT 'EventPhoto' AS photoable_type, event_photos.id AS photoable_id,
           events.starts_at AS sort_date, events.activity_id AS activity_id
      FROM event_photos
      INNER JOIN events ON events.id = event_photos.event_id
      INNER JOIN active_storage_attachments ON active_storage_attachments.record_type = 'EventPhoto'
        AND active_storage_attachments.record_id = event_photos.id
        AND active_storage_attachments.name = 'image'
     WHERE events.published = TRUE
  SQL

  # Returns [Pagy, Array<ArticlePhoto|EventPhoto>] for one page of the
  # combined, filtered, most-recent-first feed.
  def self.page(activity_id: nil, year: nil, page: 1, per_page: PER_PAGE)
    binds = { published_status: Article.statuses.fetch(:published), activity_id: activity_id.to_i, year: year.to_i }
    filtered_sql = sanitize(
      "SELECT * FROM (#{UNION_SQL}) AS gallery_photos#{where_clause(activity_id, year)}", binds
    )

    total = ActiveRecord::Base.connection.select_value("SELECT COUNT(*) FROM (#{filtered_sql}) AS counted").to_i
    pagy = Pagy.new(count: total, page: page, limit: per_page)

    rows = ActiveRecord::Base.connection.select_all(sanitize(
      "#{filtered_sql} ORDER BY sort_date DESC NULLS LAST LIMIT :limit OFFSET :offset",
      limit: per_page.to_i, offset: pagy.offset.to_i
    ))

    [ pagy, load_records(rows) ]
  end

  # Distinct years present in the combined feed, for the year-filter list --
  # driven by real data, never a guessed range.
  def self.years
    sql = sanitize(
      "SELECT DISTINCT #{LOCAL_YEAR_SQL}::int AS year " \
      "FROM (#{UNION_SQL}) AS gallery_photos WHERE sort_date IS NOT NULL ORDER BY year DESC",
      published_status: Article.statuses.fetch(:published)
    )
    ActiveRecord::Base.connection.select_values(sql)
  end

  def self.where_clause(activity_id, year)
    conditions = []
    conditions << "activity_id = :activity_id" if activity_id.present?
    conditions << "#{LOCAL_YEAR_SQL} = :year" if year.present?
    conditions.any? ? " WHERE #{conditions.join(' AND ')}" : ""
  end
  private_class_method :where_clause

  def self.sanitize(sql, binds)
    ActiveRecord::Base.sanitize_sql_array([ sql, binds ])
  end
  private_class_method :sanitize

  # Batch-loads the real records for one page of union rows, then puts
  # them back in the union query's own order -- two IN queries total,
  # never N+1 regardless of page size.
  def self.load_records(rows)
    grouped = rows.group_by { |row| row["photoable_type"] }

    article_photos = load_type(ArticlePhoto, :article, grouped["ArticlePhoto"])
    event_photos = load_type(EventPhoto, :event, grouped["EventPhoto"])

    rows.filter_map do |row|
      row["photoable_type"] == "ArticlePhoto" ? article_photos[row["photoable_id"]] : event_photos[row["photoable_id"]]
    end
  end
  private_class_method :load_records

  def self.load_type(klass, parent_association, rows)
    return {} if rows.blank?

    klass.where(id: rows.map { |row| row["photoable_id"] }).includes(parent_association).index_by(&:id)
  end
  private_class_method :load_type
end
