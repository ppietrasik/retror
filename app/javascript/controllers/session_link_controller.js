import { Controller } from "stimulus"

export default class extends Controller {
  async copy() {
    await navigator.clipboard.writeText(this.pageLink);
  }

  get pageLink () {
    return window.location.href;
  }
}
