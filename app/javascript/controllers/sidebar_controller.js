import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    const toggler = document.querySelectorAll(".btn");
    toggler.forEach((btn) => {
      btn.addEventListener("click",function(){
        document.querySelector("#sidebar").classList.toggle("collapsed");
      });
    })

  }
}

