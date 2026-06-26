import {Controller} from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["pre"]
  static values = {
    speed: {type: Number, default: 0.35},
    wavelength: {type: Number, default: 11},
    thickness: {type: Number, default: 0.37},
    decay: {type: Number, default: 1.30},
    noise: {type: Number, default: 0.26},

    chars: {type: String, default: " .:-=+*#%@"}
  }

  connect() {
    this.measureCharacters()

    this.resizeObserver = new ResizeObserver(() => {
      this.measureCharacters()
    })

    this.resizeObserver.observe(this.element)

    this.frame = this.frame.bind(this)
    this.animationFrame = requestAnimationFrame(this.frame)
  }

  disconnect() {
    cancelAnimationFrame(this.animationFrame)
    this.resizeObserver?.disconnect()
  }

  noise(x, y) {
    return (
      Math.sin(x * 12.9898 + y * 78.233) *
      43758.5453
    ) % 1
  }

  frame(timestamp) {
    const t = timestamp * 0.001 * this.speedValue

    const W = this.width
    const H = this.height

    const cx = 5
    const cy = 3

    let output = ""

    for (let y = 0; y < H; y++) {
      for (let x = 0; x < W; x++) {
        const dx = x - cx
        const dy = y - cy

        let d = Math.sqrt(dx * dx + dy * dy)

        d +=
          this.noise(x * 0.15, y * 0.15) *
          this.noiseValue *
          6

        const phase =
          d / this.wavelengthValue - t

        let wave = Math.cos(
          phase * Math.PI * 2
        )

        wave = Math.pow(
          Math.max(0, wave),
          1 / this.thicknessValue
        )

        const decay = Math.exp(
          (-d /
            (this.wavelengthValue * 4)) *
          this.decayValue
        )

        const intensity = wave * decay

        const idx = Math.min(
          this.charsValue.length - 1,
          Math.floor(
            intensity *
            this.charsValue.length *
            1.8
          )
        )

        output += this.charsValue[idx]
      }

      output += "\n"
    }

    this.preTarget.textContent = output

    this.animationFrame =
      requestAnimationFrame(this.frame)
  }

  measureCharacters() {
    const probe = document.createElement("span")

    probe.textContent = "M"
    probe.style.fontFamily = "monospace"
    probe.style.visibility = "hidden"

    document.body.appendChild(probe)

    const charWidth = probe.getBoundingClientRect().width
    const charHeight = probe.getBoundingClientRect().height

    document.body.removeChild(probe)

    const rect = this.element.getBoundingClientRect()

    this.width = Math.max(
      10,
      Math.floor(rect.width / charWidth)
    )

    this.height = Math.max(
      5,
      Math.floor(rect.height / charHeight)
    )
  }
}
