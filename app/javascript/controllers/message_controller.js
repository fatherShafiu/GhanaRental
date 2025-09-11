import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input"]

  reset() {
    this.inputTarget.value = ""
  }

  scrollToBottom() {
    const messagesContainer = document.getElementById(`messages_${this.data.get("conversationId")}`)
    if (messagesContainer) {
      messagesContainer.scrollTop = messagesContainer.scrollHeight
    }
  }
}
