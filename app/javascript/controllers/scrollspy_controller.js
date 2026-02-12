import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["section"]
  static values = { offset: Number }

  connect() {
    const rootMarginTop = -(this.offsetValue || 0)
    this.observer = new IntersectionObserver(
      (entries) => {
        const visible = entries
          .filter(e => e.isIntersecting)
          .sort((a, b) => b.intersectionRatio - a.intersectionRatio)[0]

        if (!visible) return

        const id = visible.target.id
        if (!id) return

        // スクロール中に履歴が汚れないよう replaceState
        const url = `${window.location.pathname}${window.location.search}#${id}`
        window.history.replaceState({}, "", url)
      },
      {
        root: null,
        threshold: [0.35, 0.5, 0.65],
        rootMargin: `${rootMarginTop}px 0px 0px 0px`
      }
    )

    this.sectionTargets.forEach((el) => this.observer.observe(el))
  }

  disconnect() {
    if (this.observer) this.observer.disconnect()
  }
}
