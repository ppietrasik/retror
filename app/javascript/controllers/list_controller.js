import { Controller } from "stimulus"
import { deleteRequest, patchRequest } from "../utils/api_requests"
import { getListUrl } from "../utils/api_urls";
import Container from "../lib/container"
import Sortable from "sortablejs" 
import { moveElement } from "../utils/dom";

export default class extends Controller {
  static values = { id: String, streamTag: String };
  static targets = [ "name", "cards" ];

  connect() {
    this._registerEvents();

    this.sortable = new Sortable(this.cardsTarget, {
      onEnd: event => this._triggerCardPositionUpdate(event),
      group: 'cards',
      swapThreshold: 0.25,
      animation: 150
    });
  }

  disconnect() {
    const dispatcher = Container.resolve("boardStreamListener").eventDispatcher;
    dispatcher.unregisterIdentifier(this.streamTagValue);
  }

  async updateName(name) {
    const url = getListUrl(this.idValue);
    await patchRequest(url, { name: name });
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
    moveElement(this.element, this.element.parentNode, position);
  }

  _onDeleteListEvent() {
    this.element.remove();
  }

  _onNewCardEvent(data) {
    this.cardsTarget.insertAdjacentHTML("beforeend", data);
  }

  _triggerCardPositionUpdate(event) {
    const cardElement = event.item;
    const listElement = event.to.parentNode;
    const newPosition = event.newIndex;

    const listController = this.application.getControllerForElementAndIdentifier(listElement, "list");
    const listId = listController.idValue;
    const cardController = this.application.getControllerForElementAndIdentifier(cardElement, "card");

    cardController.updatePosition(newPosition, listId); // WIP
  }
}
