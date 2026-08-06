# व्यक्ती पान -- "the quiet differentiator" (docs/03-data-model.md): an
# automatic page per person listing everything they've been mentioned in.
class PeopleController < ApplicationController
  def show
    @person = Person.find_by!(slug: params[:slug])
    @articles = @person.articles.published.order(published_at: :desc)
  end
end
