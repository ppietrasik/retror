import { Controller } from "stimulus"
import { postRequest } from "../utils/api_requests"
import { getCreateListUrl } from "../utils/api_urls"
import BoardStreamListener from "../lib/board_stream_listener";

export default class extends Controller {
  static values = { id: String };
  static targets = [ "lists" ];

  connect() {
    BoardStreamListener.connect(this.idValue);
    this._registerEvents();
  }

  disconnect() {
    BoardStreamListener.disconnect();
  }

  async createList(event) {
    event.preventDefault();

    const url = getCreateListUrl(this.idValue);
    await postRequest(url, { name: "" });
  }

  _registerEvents(){
    const dispatcher = BoardStreamListener.eventDispatcher;

    dispatcher.register(`Board:${this.idValue}`, "NewList", data => this._onNewListEvent(data));
  }

  _onNewListEvent(data) {
    this.listsTarget.insertAdjacentHTML('beforeend', data);
  }
}
