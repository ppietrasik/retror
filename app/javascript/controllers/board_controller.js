import { Controller } from "stimulus"
import { postRequest } from "../utils/api_requests"
import { getCreateListUrl } from "../utils/api_urls"
import Container from "../lib/container"
import Sortable from "sortablejs" 

export default class extends Controller {
  static values = { id: String, streamTag: String };
  static targets = [ "lists" ];

  connect() {
    this._registerEvents();
    this.sortable = new Sortable(this.listsTarget, { 
      onEnd: event => this._triggerPositionUpdate(event), 
      direction: "horizontal",
      swapThreshold: 0.25,
      animation: 150
    });
  }

  async createList(event) {
    event.preventDefault();

    const url = getCreateListUrl(this.idValue);
    await postRequest(url, { name: "" });
  }

  _registerEvents() {
    const dispatcher = Container.resolve("boardStreamListener").eventDispatcher;
    
    dispatcher.register(this.streamTagValue, "NewList", data => this._onNewListEvent(data));
  }

  _onNewListEvent(data) {
    this.listsTarget.insertAdjacentHTML("beforeend", data);
  }

  _triggerPositionUpdate(event) {
    const listElement = event.item;
    const newPosition = event.newIndex;
    const listController = this.application.getControllerForElementAndIdentifier(listElement, "list");

    listController.updatePosition(newPosition); // WIP
  }
}
