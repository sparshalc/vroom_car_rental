import { Application } from "@hotwired/stimulus"
import Lightbox from '@stimulus-components/lightbox'

const application = Application.start()

application.register('lightbox', Lightbox)

application.debug = false

window.Stimulus   = application

export { application }

document.addEventListener('turbo:load', () => {
  const swiperElements = document.querySelectorAll('.swiper');
  
  swiperElements.forEach(swiperElement => {
    new Swiper(swiperElement, {
      pagination: {
        el: swiperElement.querySelector('.swiper-pagination'),
      },
      loop: true,
      
      navigation: {
        nextEl: swiperElement.querySelector('.swiper-button-next'),
        prevEl: swiperElement.querySelector('.swiper-button-prev'),
      },
    });
  });
});
