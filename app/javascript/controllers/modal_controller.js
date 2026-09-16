import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    if (!this.element.open) this.element.showModal()
  }

  close() {
    this.element.close()
  }

  closeOnBackdrop(event) {
    if (event.target === this.element) this.close()
  }
}
