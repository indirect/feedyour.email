// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"

function setUpClipboardCopy() {
  document.querySelectorAll(".clipboard-copy").forEach(el => {
    el.addEventListener("click", function(e) {
      let code = this.querySelector("code")
      let selection = window.getSelection()
      selection.removeAllRanges()
      let range = document.createRange()
      range.selectNode(code)
      selection.addRange(range)
      if (navigator.clipboard) {
        navigator.clipboard.writeText(code.innerText).then(() => {
          this.querySelector("svg.clip-success").classList.remove("hidden")
        }).catch(() => {
          this.querySelector("svg.clip-failure").classList.remove("hidden")
        }).finally(() => {
          this.querySelector("svg.clip-empty").classList.add("hidden")
        })
      } else {
        this.querySelector("svg.clip-empty").classList.add("hidden")
        this.querySelector("svg.clip-failure").classList.remove("hidden")
      }
    })
  })
}

document.addEventListener("turbo:load", setUpClipboardCopy)
setUpClipboardCopy()
