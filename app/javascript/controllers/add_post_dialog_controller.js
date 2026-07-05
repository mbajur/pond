import {Controller} from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["frame"]

  open(e) {
    this.frameTarget.src = e.detail.url
  }
}
