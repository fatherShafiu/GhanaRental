import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["advanced"]

  connect() {
    this.timeout = null
  }

  toggleAdvanced() {
    this.advancedTarget.classList.toggle('hidden')
  }

  submit(event) {
    // Prevent default form submission for Turbo
    event.preventDefault()
    this.element.requestSubmit()
  }

  // Debounced search for better performance
  search(event) {
    clearTimeout(this.timeout)
    this.timeout = setTimeout(() => {
      this.element.requestSubmit()
    }, 500)
  }
}
