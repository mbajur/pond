import {Controller} from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["fileInput", "preview"]

  handleChange(event) {
    const maxAllowedSize = 2 * 1024 * 1024; // 2MB

    if (this.fileInputTarget.files[0].size > maxAllowedSize) {
      alert('The selected file exceeds the maximum allowed size of 2MB. Please choose a smaller file.');
      this.fileInputTarget.value = ''
    } else {
      this.preview()
    }
  }

  preview() {
    const file = this.fileInputTarget.files?.[0]

    this.cleanup()
    this.previewTarget.innerHTML = ""

    if (!file) return

    this.objectUrl = URL.createObjectURL(file)

    const img = document.createElement("img")
    img.src = this.objectUrl
    img.alt = "Preview"

    this.previewTarget.appendChild(img)
  }

  cleanup() {
    if (this.objectUrl) {
      URL.revokeObjectURL(this.objectUrl)
      this.objectUrl = null
    }
  }
}
