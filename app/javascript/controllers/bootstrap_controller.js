import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="bootstrap"
export default class extends Controller {
  connect() {
    this.modal = new bootstrap.Modal(this.element, {
      keyboard: false
    })  
    this.modal.show()
  }
  disconnect(){
    this.modal.hide()
  }
  submitEnd(event){
    this.modal.hide()
  }
}