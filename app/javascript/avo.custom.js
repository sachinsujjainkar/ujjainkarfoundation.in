// Avo's own JS extension point (app/views/avo/partials/_head.html.erb).
//
// WhatsApp-style paste for Trix (body_mr/body_en on the article editor,
// app/avo/resources/article.rb) -- Sachin's request: reporters draft on
// WhatsApp and paste into the admin, and WhatsApp's own formatting
// (*bold*, _italic_, ~strikethrough~) is plain-text markup, not real
// HTML. Trix has no idea what to do with a literal asterisk, so a pasted
// "*ठळक*" would show up as the literal characters, not bold text.
//
// A single document-level delegated `paste` listener, not a Stimulus
// controller -- Avo generates the <trix-editor> markup itself (from the
// :trix field type), so there's no template of ours to attach a
// data-controller to, and a new one appears fresh every time an editor
// form renders. Delegation from `document` sidesteps needing to know
// when/where that happens.
//
// Only intervenes when the pasted text actually looks like WhatsApp
// markdown (contains *bold*/_italic_/~strike~ syntax) -- an ordinary
// paste (from Word, another Trix field, or plain text with a stray
// underscore that isn't meant as formatting) is left to Trix's own
// default paste handling untouched.
function escapeHtml(text) {
  return text.replace(/&/g, "&amp;").replace(/</g, "&lt;").replace(/>/g, "&gt;")
}

function looksLikeWhatsAppMarkdown(text) {
  return /\*[^*\n]+\*/.test(text) || /_[^_\n]+_/.test(text) || /~[^~\n]+~/.test(text)
}

function whatsAppMarkdownToHtml(text) {
  return escapeHtml(text)
    .replace(/\*([^*\n]+)\*/g, "<strong>$1</strong>")
    .replace(/_([^_\n]+)_/g, "<em>$1</em>")
    .replace(/~([^~\n]+)~/g, "<del>$1</del>")
    .replace(/\n/g, "<br>")
}

document.addEventListener("paste", (event) => {
  const editorElement = event.target.closest && event.target.closest("trix-editor")
  if (!editorElement || !editorElement.editor) return

  const text = event.clipboardData && event.clipboardData.getData("text/plain")
  if (!text || !looksLikeWhatsAppMarkdown(text)) return

  event.preventDefault()
  editorElement.editor.insertHTML(whatsAppMarkdownToHtml(text))
})
