import { Controller } from "@hotwired/stimulus"
import * as htmlToImage from "html-to-image"

// पोस्टर generator (Phase 11) -- composes the poster as real HTML/CSS
// (app/assets/stylesheets/poster.css) and rasterises it client-side with
// html-to-image, which serialises the DOM into an SVG <foreignObject> and
// lets the BROWSER shape the text (HarfBuzz) before drawing it to canvas.
// This is the whole reason this isn't server-side ImageMagick --
// see prompts/phase-11-poster-generator.md's "critical technical
// constraint". Conjunct correctness (क्ष ज्ञ त्र श्र) rides entirely on
// the browser's own text shaping, never re-implemented here.
const MARATHI_DIGITS = "०१२३४५६७८९"
const MARATHI_MONTHS_ABBR = [
  "", "जाने", "फेब्रु", "मार्च", "एप्रि", "मे", "जून",
  "जुलै", "ऑगस्ट", "सप्टें", "ऑक्टो", "नोव्हें", "डिसें"
]
const MAX_EXPORT_BYTES = 1024 * 1024
const FONTS_TO_WARM = [
  '400 60px "Tiro Devanagari Marathi"',
  '400 40px "Mukta"',
  '700 40px "Mukta"',
  '400 40px "Source Serif 4"',
  '400 30px "Inter"',
  '600 30px "Inter"'
]

function toDevanagariDigits(n) {
  return String(n).replace(/[0-9]/g, (d) => MARATHI_DIGITS[d])
}

export default class extends Controller {
  static targets = [
    "templatePicker", "variantSwatches", "festivalControls", "festivalPicker",
    "downloadButton", "shareButton", "status", "scaleWrap", "stage",
    "photoFrame", "photoImg",
    "newsHeadline", "newsMeta",
    "eventHeadline", "eventDateBadge", "eventDay", "eventMonth", "eventVenue",
    "awardTitle", "awardHeadline",
    "festivalHeadline", "festivalMeta",
    "quoteHeadline", "quoteMeta"
  ]

  static values = {
    slug: String,
    headline: String,
    dateline: String,
    eventDate: String,
    eventVenue: String,
    photoUrl: String,
    logoUrl: String
  }

  connect() {
    this.lastBlob = null
    this.fitStage()
    window.addEventListener("resize", () => this.fitStage())
    this.setupPhotoDrag()
    this.populateEventDate()

    if (this.hasShareButtonTarget) {
      const canShareFiles = typeof navigator.canShare === "function" &&
        navigator.canShare({ files: [ new File([ "x" ], "x.png", { type: "image/png" }) ] })
      this.shareButtonTarget.style.display = canShareFiles ? "" : "none"
    }
  }

  // ---------- template / size / variant / festival ----------

  changeTemplate(event) {
    const chosen = event.target.value
    this.stageTarget.querySelectorAll(".poster-template").forEach((el) => {
      el.dataset.active = el.dataset.template === chosen ? "true" : "false"
    })
    if (this.hasFestivalControlsTarget) {
      this.festivalControlsTarget.style.display = chosen === "festival" ? "block" : "none"
    }
  }

  changeSize(event) {
    this.stageTarget.dataset.size = event.target.value
    this.fitStage()
  }

  changeVariant(event) {
    const button = event.target.closest("[data-variant]")
    if (!button) return

    this.stageTarget.dataset.variant = button.dataset.variant
    this.variantSwatchesTarget.querySelectorAll("[data-variant]").forEach((el) => {
      el.setAttribute("aria-pressed", el === button ? "true" : "false")
    })
  }

  changeFestival(event) {
    if (this.hasFestivalHeadlineTarget) this.festivalHeadlineTarget.textContent = event.target.value
  }

  // ---------- on-screen scaling (export always uses the real 1080/1920 box) ----------

  fitStage() {
    const wrapWidth = this.scaleWrapTarget.parentElement.clientWidth - 32
    const stageWidth = 1080
    const stageHeight = this.stageTarget.dataset.size === "status" ? 1920 : 1080
    const scale = Math.min(1, wrapWidth / stageWidth)

    this.scaleWrapTarget.style.transform = `scale(${scale})`
    this.scaleWrapTarget.style.width = `${stageWidth}px`
    this.scaleWrapTarget.style.height = `${stageHeight}px`
    // Reserve the SCALED box in normal flow -- a CSS transform doesn't
    // shrink the element's own layout footprint, so without this the
    // preview pane would keep the full 1080/1920px of blank space below
    // the visually-scaled-down poster.
    this.scaleWrapTarget.parentElement.style.height = `${stageHeight * scale}px`
  }

  // ---------- event date badge ----------

  populateEventDate() {
    if (!this.hasEventDayTarget || !this.eventDateValue) return

    const date = new Date(this.eventDateValue)
    if (Number.isNaN(date.getTime())) return

    this.eventDayTarget.textContent = toDevanagariDigits(date.getDate())
    this.eventMonthTarget.textContent = MARATHI_MONTHS_ABBR[date.getMonth() + 1]
  }

  // ---------- photo reposition (drag on the frame, object-position) ----------

  setupPhotoDrag() {
    this.photoFrameTargets.forEach((frame) => {
      const img = frame.querySelector("img")
      if (!img) return

      let dragging = false
      let posX = 50
      let posY = 50

      frame.addEventListener("pointerdown", (event) => {
        dragging = true
        frame.setPointerCapture(event.pointerId)
      })
      frame.addEventListener("pointermove", (event) => {
        if (!dragging) return
        const rect = frame.getBoundingClientRect()
        posX = Math.min(100, Math.max(0, ((event.clientX - rect.left) / rect.width) * 100))
        posY = Math.min(100, Math.max(0, ((event.clientY - rect.top) / rect.height) * 100))
        img.style.objectPosition = `${posX}% ${posY}%`
      })
      const stopDrag = () => { dragging = false }
      frame.addEventListener("pointerup", stopDrag)
      frame.addEventListener("pointercancel", stopDrag)
    })
  }

  // ---------- rasterise + export ----------

  // Explicitly kicks off a load for every font/weight the poster actually
  // uses, THEN waits on document.fonts.ready -- a hidden template's fonts
  // (e.g. festival, never shown by default) may not have been requested
  // by the browser yet just from being declared in @font-face, and
  // .ready only waits on fonts already in flight. Rasterising before this
  // resolves is exactly the "silently falls back to a system font"
  // failure prompts/phase-11-poster-generator.md warns about.
  async ensureFontsReady() {
    await Promise.all(FONTS_TO_WARM.map((f) => document.fonts.load(f)))
    await document.fonts.ready
  }

  async rasterise(pixelRatio) {
    return htmlToImage.toBlob(this.stageTarget, {
      pixelRatio,
      cacheBust: true,
      backgroundColor: getComputedStyle(this.stageTarget).backgroundColor
    })
  }

  async generate() {
    this.statusTarget.textContent = "तयार करत आहे…"
    await this.ensureFontsReady()

    let blob = await this.rasterise(2)
    if (blob && blob.size > MAX_EXPORT_BYTES) {
      // A very detailed photo can push a 2x export over 1MB -- retry at
      // 1x before giving up and just being honest about the size in the
      // status line. Never silently ship something WhatsApp will
      // recompress into mush (prompts/phase-11, "Export" task).
      const smaller = await this.rasterise(1)
      if (smaller && smaller.size < blob.size) blob = smaller
    }

    this.lastBlob = blob
    return blob
  }

  filename() {
    return `${this.slugValue || "poster"}-poster.png`
  }

  async download() {
    try {
      const blob = await this.generate()
      const url = URL.createObjectURL(blob)
      const link = document.createElement("a")
      link.href = url
      link.download = this.filename()
      link.click()
      URL.revokeObjectURL(url)

      const kb = Math.round(blob.size / 1024)
      this.statusTarget.textContent = blob.size > MAX_EXPORT_BYTES
        ? `डाउनलोड झाले (${kb} KB — १ MB पेक्षा मोठे, फोटो बदलून पुन्हा प्रयत्न करा)`
        : `डाउनलोड झाले (${kb} KB)`
    } catch (error) {
      this.statusTarget.textContent = "पोस्टर तयार करता आले नाही. पुन्हा प्रयत्न करा."
      console.error(error)
    }
  }

  async share() {
    try {
      const blob = await this.generate()
      const file = new File([ blob ], this.filename(), { type: "image/png" })

      if (navigator.canShare && navigator.canShare({ files: [ file ] })) {
        await navigator.share({ files: [ file ], title: this.headlineValue, text: this.headlineValue })
        this.statusTarget.textContent = "पाठवले."
      } else {
        await this.download()
      }
    } catch (error) {
      if (error && error.name === "AbortError") return // user closed the share sheet

      this.statusTarget.textContent = "पाठवता आले नाही. डाउनलोड करून पहा."
      console.error(error)
    }
  }
}
