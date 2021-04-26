import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "container", "ignored" ];

  toggle() {
    this.containerTarget.classList.toggle("hidden");
  }

  clear(event) {
    const shouldHide = this.ignoredTargets.every(element => element != event.target);

    if(shouldHide) this.containerTarget.classList.add("hidden");
  }
}
