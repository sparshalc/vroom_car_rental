import { Controller } from "@hotwired/stimulus";

export default class extends Controller {

  copyLink() {
    navigator.clipboard.writeText(this.element.dataset.shareUrl).then(() => {
      alert("Copied to clipboard");
    });
  }

  whatsappShare() {
    window.open(`https://web.whatsapp.com:/send?text=${this.element.dataset.shareUrl}`);
  }
  
  twitterShare() {
    window.open(`https://twitter.com/share?url=${this.element.dataset.shareUrl}`);
    
  }

  embedLink() {
    const embedCode = `<iframe src="${this.element.dataset.shareUrl}" width="600" height="400"></iframe>`;
    navigator.clipboard.writeText(embedCode).then(() => {
      alert("Copied to clipboard");
    });
  }
}
