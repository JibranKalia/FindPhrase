import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="scroll-to-segment"
export default class extends Controller {
  static values = { segmentId: String }

  connect() {
    this.scrollToTarget()
  }

  scrollToTarget() {
    if (!this.segmentIdValue) return
    
    const targetSegment = document.getElementById(`segment-${this.segmentIdValue}`)
    if (targetSegment) {
      // Small delay to ensure DOM is fully rendered
      setTimeout(() => {
        targetSegment.scrollIntoView({ behavior: 'smooth', block: 'center' })
      }, 100)
    }
  }
}