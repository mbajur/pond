import {Controller} from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["frame", "prepopulateInput"]

  connect() {
    this.prepopulateValue = null
  }

  open(e) {
    this.frameTarget.src = e.detail.url
  }

  onFrameLoad() {
    if (!this.prepopulateValue) return
    if (!this.hasPrepopulateInputTarget) return

    // @todo Move that out of here. It should just dispatch the event and let the other controller handle it.
    //   This controller should just be responsible for opening the dialog and passing the value to the other controller.
    if (this.prepopulateValue instanceof File) {
      const dt = new DataTransfer()
      dt.items.add(this.prepopulateValue)

      this.prepopulateInputTarget.files = dt.files
      this.prepopulateInputTarget.dispatchEvent(new Event("change"))
    } else {
      this.prepopulateInputTarget.value = this.prepopulateValue
      this.prepopulateInputTarget.focus()
    }

    this.prepopulateValue = null
  }

  storePrepopulateValue(e) {
    this.prepopulateValue = e.detail.value
  }
}
