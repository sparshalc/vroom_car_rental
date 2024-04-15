import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
    this.locationButtonTarget.addEventListener("click", () => {
      if (navigator.geolocation) {
        this.locationFlashMessages.innerText = "Please wait...";

        navigator.geolocation.getCurrentPosition(
          this.showLocation.bind(this),
          this.checkError.bind(this)
        );
      } else {
        this.locationFlashMessages.innerText = "The browser does not support geolocation";
      }
    });
  }

  async showLocation(position) {
    try {
      let response = await fetch(
        `https://nominatim.openstreetmap.org/reverse?lat=${position.coords.latitude}&lon=${position.coords.longitude}&format=json`
      );
      let data = await response.json();
      this.locationDivTarget.value = `${data.address.suburb}, ${data.address.city}`;
      this.locationFlashMessages.innerText = "";
    } catch (error) {
      this.locationFlashMessages.innerText = "Error fetching location data";
    }
  }

  checkError(error) {
    switch (error.code) {
      case error.PERMISSION_DENIED:
        this.locationFlashMessages.innerText = "Please allow access to location";
        break;
      case error.POSITION_UNAVAILABLE:
        this.locationFlashMessages.innerText = "Location information unavailable";
        break;
      case error.TIMEOUT:
        this.locationFlashMessages.innerText = "The request to get user location timed out";
        break;
      default:
        this.locationFlashMessages.innerText = "An unknown error occurred";
        break;
    }
  }

  get locationButtonTarget() {
    return this.element.querySelector("#get-location");
  }

  get locationDivTarget() {
    return this.element.querySelector("#location-details");
  }

  get locationFlashMessages() {
    return this.element.querySelector("#location-message");
  }
}
