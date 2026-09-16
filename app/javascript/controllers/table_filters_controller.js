import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  submit() {
    clearTimeout(this.timeout)
    this.timeout = setTimeout(() => this.element.requestSubmit(), 250)
  }

  submitNow() {
    clearTimeout(this.timeout)
    this.element.requestSubmit()
  }

  clear() {
    clearTimeout(this.timeout)

    this.element.querySelectorAll("input:not([type=submit]), select").forEach((control) => {
      control.value = ""
    })
  }

  disconnect() {
    clearTimeout(this.timeout)
  }
}
