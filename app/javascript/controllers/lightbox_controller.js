import { Controller } from "@hotwired/stimulus"

// गॅलरी lightbox -- keyboard (arrows, Escape) and swipe navigable, shows
// the Marathi caption and credit. No external library --
// prompts/phase-10-events-gallery.md: "No heavy library; a Stimulus
// controller is enough."
export default class extends Controller {
  static targets = ["item", "overlay", "image", "caption", "credit"]

  connect() {
    this.currentIndex = 0
    this.touchStartX = null
    this.onKeydown = this.onKeydown.bind(this)
  }

  disconnect() {
    document.removeEventListener("keydown", this.onKeydown)
  }

  open(event) {
    this.currentIndex = this.itemTargets.indexOf(event.currentTarget)
    this.render()
    // Toggle "hidden"/"flex" together, never both classes at once -- with
    // both present simultaneously, which display wins depends on Tailwind's
    // internal utility ordering rather than anything declared here.
    this.overlayTarget.classList.remove("hidden")
    this.overlayTarget.classList.add("flex")
    document.body.classList.add("overflow-hidden")
    document.addEventListener("keydown", this.onKeydown)
    this.overlayTarget.focus()
  }

  close() {
    this.overlayTarget.classList.add("hidden")
    this.overlayTarget.classList.remove("flex")
    document.body.classList.remove("overflow-hidden")
    document.removeEventListener("keydown", this.onKeydown)
  }

  prev() {
    this.currentIndex = (this.currentIndex - 1 + this.itemTargets.length) % this.itemTargets.length
    this.render()
  }

  next() {
    this.currentIndex = (this.currentIndex + 1) % this.itemTargets.length
    this.render()
  }

  render() {
    const item = this.itemTargets[this.currentIndex]
    this.imageTarget.src = item.dataset.full
    this.captionTarget.textContent = item.dataset.caption || ""
    this.creditTarget.textContent = item.dataset.credit || ""
  }

  onKeydown(event) {
    if (event.key === "Escape") this.close()
    else if (event.key === "ArrowLeft") this.prev()
    else if (event.key === "ArrowRight") this.next()
  }

  touchStart(event) {
    this.touchStartX = event.changedTouches[0].clientX
  }

  touchEnd(event) {
    if (this.touchStartX === null) return

    const delta = event.changedTouches[0].clientX - this.touchStartX
    if (delta > 40) this.prev()
    else if (delta < -40) this.next()
    this.touchStartX = null
  }
}
