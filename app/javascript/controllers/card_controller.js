import { deleteRequest, patchRequest } from "../utils/api_requests"
import { getCardUrl } from "../utils/api_urls";
import { findListElement, moveElement }  from "../utils/dom";
import Container from "../lib/container"
import { Controller } from "stimulus"

export default class extends Controller {
  static values = { id: String, streamTag: String };
  static targets = [ "note" ];

  connect() {
    this._registerEvents();
  }

  disconnect() {
    const dispatcher = Container.resolve("boardStreamListener").eventDispatcher;
    dispatcher.unregisterIdentifier(this.streamTagValue);
  }

  async updateNote(note) {
    const url = getCardUrl(this.idValue);
    await patchRequest(url, { note: note });
  }
  
  async delete() {
    const url = getCardUrl(this.idValue);
    await deleteRequest(url);
  }

  async updatePosition(position, listId) {
    const url = getCardUrl(this.idValue);
    await patchRequest(url, { position: position, list_id: listId });
  }

  set noteValue(note) {
    this.noteTarget.value = note;
  }

  _registerEvents() {
    const dispatcher = Container.resolve("boardStreamListener").eventDispatcher;

    dispatcher.register(this.streamTagValue, "UpdateCard", data => this._onUpdateCardEvent(data));
    dispatcher.register(this.streamTagValue, "DeleteCard", _ => this._onDeleteCardEvent());
  }

  _onUpdateCardEvent({ note, position, list_id }) {
    this.noteValue = note;

    const listElement = findListElement(list_id);
    const listController = this.application.getControllerForElementAndIdentifier(listElement, "list"); // WIP

    moveElement(this.element, listController.cardsTarget, position);
  }

  _onDeleteCardEvent() {
    this.element.remove();
  }
}
