import {Controller} from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["urlBtn", "textBtn", "imageBtn"]

  connect() {
    this.onPaste = this.onPaste.bind(this)
    window.addEventListener("paste", this.onPaste)
  }

  disconnect() {
    window.removeEventListener("paste", this.onPaste)
  }

  onPaste(event) {
    if (this.isEditableElement(document.activeElement)) return

    const imageItem = [...(event.clipboardData?.items || [])].find(item =>
      item.type.startsWith("image/")
    )

    if (imageItem) {
      const file = imageItem.getAsFile()

      if (!file) return

      event.preventDefault()

      this.dispatch("prepopulate", {
        prefix: "remote-dialog-btn",
        detail: {value: file}
      })

      this.imageBtnTarget.click()
      return
    }

    const text = event.clipboardData?.getData("text")?.trim()

    if (!text) return

    event.preventDefault()

    this.dispatch("prepopulate", {
      prefix: "remote-dialog-btn",
      detail: {value: text}
    })

    if (this.isUrl(text)) {
      this.urlBtnTarget.click()
    } else {
      this.textBtnTarget.click()
    }
  }

  isEditableElement(element) {
    if (!element) return false
    if (element.isContentEditable) return true

    const tag = element.tagName
    return tag === "INPUT" || tag === "TEXTAREA" || tag === "SELECT"
  }

  isUrl(value) {
    try {
      const url = new URL(value)
      return url.protocol === "http:" || url.protocol === "https:"
    } catch {
      return false
    }
  }
}
