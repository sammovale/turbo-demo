import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "all", "checkbox", "count", "submit" ]

  connect() {
    this.refresh()
  }

  checkboxTargetConnected() {
    this.scheduleRefresh()
  }

  checkboxTargetDisconnected() {
    this.scheduleRefresh()
  }

  toggleAll() {
    this.checkboxTargets.forEach((checkbox) => {
      checkbox.checked = this.allTarget.checked
    })
    this.refresh()
  }

  selectionChanged() {
    this.refresh()
  }

  refresh() {
    const selectedCount = this.checkboxTargets.filter((checkbox) => checkbox.checked).length
    const allSelected = selectedCount === this.checkboxTargets.length && selectedCount > 0

    this.countTarget.textContent = `${selectedCount} selected`
    this.submitTarget.disabled = selectedCount === 0
    this.allTarget.checked = allSelected
    this.allTarget.indeterminate = selectedCount > 0 && !allSelected
  }

  scheduleRefresh() {
    clearTimeout(this.refreshTimeout)
    this.refreshTimeout = setTimeout(() => this.refresh())
  }

  disconnect() {
    clearTimeout(this.refreshTimeout)
  }
}
