# "An admin button on any published article" -- prompts/phase-11-poster-generator.md,
# task 3. Not a mutation, just navigation to the poster editor tool
# (Avo::ToolsController#poster) -- Avo's Action mechanism is the only
# button-with-a-visible-condition primitive Avo community actually gives a
# resource show page (no `as: :external_link` field in this Avo version --
# checked the gem's own lib/avo/fields directory, not assumed), so it's
# used here purely for its redirect, not its confirm-and-mutate shape.
class Avo::Actions::GeneratePoster < Avo::BaseAction
  self.name = "पोस्टर तयार करा"
  self.standalone = false
  self.no_confirmation = true
  # The visible block's lambda only gets the keywords Avo::ExecutionContext
  # was actually called with (resource/view/arguments/parent_resource) --
  # no bare `record` local. Confirmed by hitting this for real: an earlier
  # `record.published?` raised NameError on the article show page.
  self.visible = -> { view.show? && resource.record.published? }

  def handle(query:, **)
    article = query.first
    redirect_to "#{Avo.configuration.root_path}/posters/#{article.id}"
  end
end
