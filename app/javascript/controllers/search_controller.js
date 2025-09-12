import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["advanced"]

  toggleAdvanced() {
    this.advancedTarget.classList.toggle('hidden')
  }

  submit(event) {
    // Auto-submit form when sort selection changes
    this.element.requestSubmit()
  }

  // Debounced search for better performance
  search(event) {
    clearTimeout(this.timeout)
    this.timeout = setTimeout(() => {
      this.element.requestSubmit()
    }, 300)
  }
}
