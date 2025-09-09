import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["filters"]

  toggleFilters() {
    this.filtersTarget.classList.toggle('hidden')
  }

  updatePriceRange() {
    const minPrice = document.getElementById('min_price').value
    const maxPrice = document.getElementById('max_price').value
    // You can add live validation here
  }
}
