import { Controller } from "@hotwired/stimulus"

// Full-screen mobile nav overlay. Focus is trapped inside while open,
// Escape and a backdrop click both close it, and focus returns to the
// trigger button on close. No external library -- see
// prompts/phase-03-layout-shell.md.
export default class extends Controller {
  static targets = ["panel", "trigger"]

  connect() {
    this.onKeydown = this.onKeydown.bind(this)
  }

  disconnect() {
    document.removeEventListener("keydown", this.onKeydown)
  }

  open() {
    this.panelTarget.classList.remove("hidden")
    document.body.classList.add("overflow-hidden")
    document.addEventListener("keydown", this.onKeydown)
    this.triggerTarget.setAttribute("aria-expanded", "true")
    this.focusables()[0]?.focus()
  }

  close() {
    if (this.panelTarget.classList.contains("hidden")) return

    this.panelTarget.classList.add("hidden")
    document.body.classList.remove("overflow-hidden")
    document.removeEventListener("keydown", this.onKeydown)
    this.triggerTarget.setAttribute("aria-expanded", "false")
    this.triggerTarget.focus()
  }

  closeOnBackdrop(event) {
    if (event.target === event.currentTarget) this.close()
  }

  onKeydown(event) {
    if (event.key === "Escape") {
      this.close()
      return
    }
    if (event.key !== "Tab") return

    const focusables = this.focusables()
    if (focusables.length === 0) return

    const first = focusables[0]
    const last = focusables[focusables.length - 1]

    if (event.shiftKey && document.activeElement === first) {
      event.preventDefault()
      last.focus()
    } else if (!event.shiftKey && document.activeElement === last) {
      event.preventDefault()
      first.focus()
    }
  }

  focusables() {
    return Array.from(
      this.panelTarget.querySelectorAll(
        'a[href], button:not([disabled]), input, select, textarea, [tabindex]:not([tabindex="-1"])'
      )
    )
  }
}
