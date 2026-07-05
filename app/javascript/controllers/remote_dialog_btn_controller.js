import {Controller} from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    url: String
  }

  openDialog() {
    this.dispatch("remote-dialog-btn-clicked", {detail: {url: this.urlValue}})
  }
}
