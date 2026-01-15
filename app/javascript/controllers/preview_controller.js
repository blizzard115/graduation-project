import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "img", "placeholder"]

  connect() {
    if (this.hasInputTarget) {
      this.inputTarget.addEventListener("change", this.preview.bind(this))
    }
  }

  preview(event) {
    const file = event.target.files?.[0]
    if (!file) return

    const reader = new FileReader()
    reader.onload = (e) => {
      this.imgTarget.src = e.target.result
      this.imgTarget.classList.remove("d-none")
      this.placeholderTarget.classList.add("d-none")
    }
    reader.readAsDataURL(file)
  }
}
