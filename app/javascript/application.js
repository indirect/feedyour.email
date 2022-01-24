// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"

document.addEventListener("turbo:before-stream-render", function(event) {
  // Add a class to an element we are about to add to the page
  // as defined by its "data-stream-enter-class"
  if (event.target.firstElementChild instanceof HTMLTemplateElement) {
    var enterAnimationClass = event.target.templateContent.firstElementChild.dataset.streamEnterClass
    if (enterAnimationClass) {
      event.target.templateElement.content.firstElementChild.classList.add(enterAnimationClass)
    }
  }

  // Add a class to an element we are about to remove from the page
  // as defined by its "data-stream-exit-class"
  var elementToRemove = document.getElementById(event.target.target)
  if (elementToRemove) {
    var streamExitClass = elementToRemove.dataset.streamExitClass
    if (streamExitClass) {
      // Intercept the removal of the element
      event.preventDefault()
      elementToRemove.classList.add(streamExitClass)
      // Wait for its animation to end before removing the element
      elementToRemove.addEventListener("animationend", function() {
        event.target.performAction()
      })
    }
  }
})

document.querySelectorAll(".toggle-feed-url").forEach(el => {
  el.addEventListener("click", e => {
    document.querySelector("#feed-url").classList.toggle("hidden")
    document.querySelector("#feed-link").classList.toggle("hidden")
    e.preventDefault()
  }, false)
})
