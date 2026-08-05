import { Controller } from "@hotwired/stimulus"

// Replaces the thumbnail+play-button facade with a real iframe, only on
// click -- see prompts/phase-06-media-pipeline.md. youtube-nocookie.com so
// no YouTube cookie is set either, until this actually runs.
export default class extends Controller {
  static values = { id: String, title: String }

  load() {
    const iframe = document.createElement("iframe")
    iframe.src = `https://www.youtube-nocookie.com/embed/${this.idValue}?autoplay=1`
    iframe.title = this.titleValue || "YouTube video"
    iframe.className = "absolute inset-0 h-full w-full"
    iframe.allow = "accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture"
    iframe.allowFullscreen = true
    iframe.setAttribute("frameborder", "0")

    this.element.replaceChildren(iframe)
  }
}
