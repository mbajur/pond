import {Controller} from "@hotwired/stimulus"
import {get} from "@rails/request.js"

export default class extends Controller {
  static targets = [
    "results",
    "pagination",
    "link"
  ]

  static values = {
    auto: {
      type: Boolean,
      default: true
    },
    rootMargin: {
      type: String,
      default: "300px"
    },
    threshold: {
      type: Number,
      default: 0
    }
  }

  connect() {
    this.observeLink()
  }

  disconnect() {
    this.observer?.disconnect()
  }

  load(event) {
    event?.preventDefault()
    return this.fetchNextPage()
  }

  observeLink() {
    if (!this.autoValue || !this.hasLinkTarget) return

    this.observer?.disconnect()

    this.observer = new IntersectionObserver(
      ([entry]) => {
        if (entry.isIntersecting) {
          this.fetchNextPage()
        }
      },
      {
        rootMargin: this.rootMarginValue,
        threshold: this.thresholdValue
      }
    )

    this.observer.observe(this.linkTarget)
  }

  async fetchNextPage() {
    if (this.loading || !this.hasLinkTarget) return

    this.loading = true
    this.observer?.disconnect()

    try {
      const response = await get(this.linkTarget.href)

      if (!response.ok) return

      const html = await response.text

      const doc = new DOMParser().parseFromString(
        html,
        "text/html"
      )

      const incomingResults = doc.querySelector(
        '[data-pagination-target="results"]'
      )

      const incomingPagination = doc.querySelector(
        '[data-pagination-target="pagination"]'
      )

      if (!incomingResults) {
        throw new Error(
          "Missing data-pagination-target='results' in response"
        )
      }

      this.resultsTarget.append(
        ...Array.from(incomingResults.children)
      )

      if (incomingPagination) {
        this.paginationTarget.replaceWith(incomingPagination)
      } else {
        this.paginationTarget.remove()
      }

      this.observeLink()
    } finally {
      this.loading = false
    }
  }
}
