import autosize from 'autosize'
import { deleteRequest, patchRequest } from "../utils/api_requests"
import { getCardUrl } from "../utils/api_urls";
import { setReadOnlySwitch, moveCaretToTheEnd }  from "../utils/dom";
import Container from "../lib/container"
import { Controller } from "stimulus"

const SUBMIT_KEY = "Enter";
const SUBMIT_EVENT_TYPE = "keydown";

export default class extends Controller {
  static values = { id: String, streamTag: String };
  static targets = [ "note" ];

  connect() {
    autosize(this.noteTarget);
    setReadOnlySwitch(this.noteTarget, "dblclick");

    this._registerEvents();
  }

  disconnect() {
    const dispatcher = Container.resolve("boardStreamListener").eventDispatcher;
    dispatcher.unregisterIdentifier(this.streamTagValue);
  }

  editNote() {
    this.noteTarget.readOnly = false;
    this.noteTarget.focus();

    moveCaretToTheEnd(this.noteTarget);
  }

  async updateNote(event) {
    if(event.type == SUBMIT_EVENT_TYPE) {
      if(event.key !== SUBMIT_KEY || event.shiftKey) return;

      this.noteTarget.blur();
      return;
    }

    const url = getCardUrl(this.idValue);
    await patchRequest(url, { note: this.noteValue });
  }
  
  async delete() {
    const url = getCardUrl(this.idValue);
    await deleteRequest(url);
  }

  get noteValue() {
    return this.noteTarget.value;
  }

  set noteValue(note) {
    this.noteTarget.value = note;
  }

  _registerEvents() {
    const dispatcher = Container.resolve("boardStreamListener").eventDispatcher;

    dispatcher.register(this.streamTagValue, "UpdateCard", data => this._onUpdateCardEvent(data));
    dispatcher.register(this.streamTagValue, "DeleteCard", _ => this._onDeleteCardEvent());
  }

  _onUpdateCardEvent({ note, position }) {
    this.noteValue = note;
  }

  _onDeleteCardEvent() {
    this.element.remove();
  }
}
