import { Controller } from "@hotwired/stimulus"

// Dismisses a single flash message. 150ms ease-out fade, matching the
// design system's one motion rule -- see docs/02-design-system.md.
export default class extends Controller {
  dismiss() {
    this.element.style.transition = "opacity 150ms ease-out"
    this.element.style.opacity = "0"
    this.element.addEventListener("transitionend", () => this.element.remove(), { once: true })
  }
}
