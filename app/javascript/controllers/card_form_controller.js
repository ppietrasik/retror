import autosize from 'autosize'
import { Controller } from "stimulus"
import { postRequest } from "../utils/api_requests"
import { getCreateCardUrl } from "../utils/api_urls"

export default class extends Controller {
  static values = { listId: String };
  static targets = [ "form", "note", "open" ];

  connect() {
    autosize(this.noteTarget);
  }

  async createNote(event) {
    event.preventDefault();

    const url = getCreateCardUrl(this.listIdValue);
    await postRequest(url, { note: this.noteValue });

    this._reset();
  }

  openForm() {
    this._toggleVisibility();
    this.noteTarget.focus();
  }

  hideForm() {
    if(this.noteValue.trim() === "")
      this._reset();
  }

  get noteValue() {
    return this.noteTarget.value;
  }

  set noteValue(value) {
    this.noteTarget.value = value;
  }

  _reset() {
    this.noteValue = "";
    this._toggleVisibility();
  }

  _toggleVisibility() {
    this.openTarget.classList.toggle("hidden");
    this.formTarget.classList.toggle("hidden");
  }
}
