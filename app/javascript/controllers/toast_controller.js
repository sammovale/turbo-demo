import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { duration: { type: Number, default: 5000 } }

  connect() {
    this.resume()
  }

  pause() {
    clearTimeout(this.timeout)
  }

  resume() {
    this.pause()
    this.timeout = setTimeout(() => this.dismiss(), this.durationValue)
  }

  dismiss() {
    this.pause()
    this.element.classList.add("toast--leaving")
    setTimeout(() => this.element.remove(), 180)
  }

  disconnect() {
    this.pause()
  }
}
