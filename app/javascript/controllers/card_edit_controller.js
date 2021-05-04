import autosize from 'autosize'
import { moveCaretToTheEnd }  from "../utils/dom";

import { Controller } from "stimulus"

const SUBMIT_KEY = "Enter";
const SUBMIT_EVENT_TYPE = "keydown";

export default class extends Controller {
  static values = { editMode: Boolean };
  static targets = [ "note" ];

  connect() {
    autosize(this.noteTarget);
    this._setupModeChange();
  }

  enterEditMode(event) {
    this.noteTarget.readOnly = false;
    this.editModeValue = true;

    this.noteTarget.focus();

    if(event.type == "click")
      moveCaretToTheEnd(this.noteTarget);
  }

  async exitEditMode(event) {
    if(!this.editModeValue) return;
    if(this._checkEventSubmit(event)) return;
    
    this.noteTarget.readOnly = true;
    this.editModeValue = false;

    this.noteTarget.blur();
    await this.cardController.updateNote(this.noteTarget.value);
  }

  get cardController() {
    return this.application.getControllerForElementAndIdentifier(this.element, "card");
  }

  async _setupModeChange() {
    this.noteTarget.addEventListener("dblclick", event => this.enterEditMode(event));
    this.noteTarget.addEventListener("blur", event => this.exitEditMode(event));
  }

  _checkEventSubmit(event) {
    return event.type == SUBMIT_EVENT_TYPE && event.key !== SUBMIT_KEY || event.shiftKey
  }
}
