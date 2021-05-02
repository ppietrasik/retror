import { Controller } from "stimulus"
import { deleteRequest, patchRequest } from "../utils/api_requests"
import { getListUrl } from "../utils/api_urls";
import Container from "../lib/container"
import { moveElement } from "../utils/dom";

const SUBMIT_EVENT_TYPE = "submit";

export default class extends Controller {
  static values = { id: String, streamTag: String };
  static targets = [ "name", "cards" ];

  connect() {
    this._registerEvents();
  }

  disconnect() {
    const dispatcher = Container.resolve("boardStreamListener").eventDispatcher;
    dispatcher.unregisterIdentifier(this.streamTagValue);
  }

  async updateName(event) {
    if(event.type === SUBMIT_EVENT_TYPE) {
      this.nameTarget.blur();
      return;
    }

    const url = getListUrl(this.idValue);
    await patchRequest(url, { name: this.nameValue });
  }

  async updatePosition(position) {
    const url = getListUrl(this.idValue);
    await patchRequest(url, { position: position });
  }

  async delete(event) {
    event.preventDefault();

    const url = getListUrl(this.idValue);
    await deleteRequest(url);
  }

  get nameValue() {
    return this.nameTarget.value;
  }

  set nameValue(name) {
    this.nameTarget.value = name;
  }

  _registerEvents() {
    const dispatcher = Container.resolve("boardStreamListener").eventDispatcher;

    dispatcher.register(this.streamTagValue, "UpdateList", data => this._onUpdateListEvent(data));
    dispatcher.register(this.streamTagValue, "DeleteList", _ => this._onDeleteListEvent());
    dispatcher.register(this.streamTagValue, "NewCard", data => this._onNewCardEvent(data));
  }

  _onUpdateListEvent({ name, position }) {
    this.nameValue = name;
    moveElement(this.element, position);
  }

  _onDeleteListEvent() {
    this.element.remove();
  }

  _onNewCardEvent(data) {
    this.cardsTarget.insertAdjacentHTML("beforeend", data);
  }
}
