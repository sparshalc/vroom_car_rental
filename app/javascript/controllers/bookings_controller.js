import { Controller } from "@hotwired/stimulus"
import flatpickr from "flatpickr";

export default class extends Controller {
  static targets = ["startDate", "endDate", "baseFair", "daysCount", "fairWithServiceFee", "totalFair", "calculations", "fairWithOutServiceFee", "pickupLocation", "dropLocation", "comment"]

  SERVICE_CHARGE_PERCENT = 0.10

  disableDates = [];

  connect() {
    this.formatBlockedDates();

    flatpickr(this.startDateTarget, {
      minDate: new Date().fp_incr(1),
      disable: this.disableDates,
      onChange: (selectedDates, dateStr, instance) => {
        this.triggetEndDatePicker(selectedDates);
      },
    });
    flatpickr(this.endDateTarget, {});
  }

  formatBlockedDates() {
    const blockedDates = JSON.parse(this.element.dataset.blockedDates)
    for(let i = 0; i < blockedDates.length; i++){
      const dates = blockedDates[i];
      this.disableDates.push(
        {
          from: dates[0], 
          to: dates[1], 
        }
      )
    }
  }

  triggetEndDatePicker(selectedDates){
    flatpickr(this.endDateTarget, {
      minDate: new Date(selectedDates).fp_incr(1),
      onChange: (selectedDates, dateStr, instance) => {
        this.updateDetails();
      },
    });
    this.endDateTarget.click();
  }

  updateDetails(){
    this.calculationsTarget.classList.remove('d-none')
    const startDate = new Date(this.startDateTarget.value);
    const endDate = new Date(this.endDateTarget.value);
    const totalDays = this.calculateDays(startDate, endDate)
    const baseFair =  this.baseFairTarget.innerHTML
    const totalFareExcludingServiceCharge = this.calculatefairWithOutServiceFeePrice(totalDays, baseFair).toFixed(2)
    const totalFareIncludingServiceCharge = this.calculatefairWithServiceFeePrice(totalDays, baseFair).toFixed(2)

    this.daysCountTarget.textContent = `${totalDays} days`
    this.fairWithOutServiceFeeTarget.textContent = `Rs. ${totalFareExcludingServiceCharge}`
    this.totalFairTarget.textContent = `Rs. ${totalFareIncludingServiceCharge}`
  }

  calculateDays(startDate, endDate){
    return (endDate - startDate) / (1000 * 60 * 60 * 24)
  }

  calculatefairWithOutServiceFeePrice(days, price){
    return (days * price)
  }

  calculatefairWithServiceFeePrice(days, price){
    const priceWithoutServiceCharge = this.calculatefairWithOutServiceFeePrice(days, price)
    return priceWithoutServiceCharge + (this.SERVICE_CHARGE_PERCENT * priceWithoutServiceCharge)
  }

  reserveProperty(e) {
    e.preventDefault();

    const paramsData = {
      start_date: this.startDateTarget.value,
      end_date: this.endDateTarget.value,
      pickup_location: this.pickupLocationTarget.value,
      drop_location: this.dropLocationTarget.value,
      comment: this.commentTarget.value,
    }

    const paramsURL = (new URLSearchParams(paramsData)).toString();

    const baseURL = e.target.dataset.reservePropertyUrl;
    Turbo.visit(`${baseURL}?${paramsURL}`);
  }
}
