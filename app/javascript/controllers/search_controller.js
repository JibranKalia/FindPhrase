import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["form"]
  static values = { debounce: { type: Number, default: 100 } }

  connect() {
    this.timeout = null
  }

  disconnect() {
    if (this.timeout) {
      clearTimeout(this.timeout)
    }
  }

  search() {
    // Clear existing timeout
    if (this.timeout) {
      clearTimeout(this.timeout)
    }

    // Debounce the search
    this.timeout = setTimeout(() => {
      this.formTarget.requestSubmit()
    }, this.debounceValue)
  }
}
