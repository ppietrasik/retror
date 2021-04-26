import { Controller } from "stimulus"
import { postRequest } from "../utils/api_requests"
import { getCreateListUrl } from "../utils/api_urls"
import Container from '../lib/container'

export default class extends Controller {
  static values = { id: String, streamTag: String };
  static targets = [ "lists" ];

  connect() {
    this._registerEvents();
  }

  async createList(event) {
    event.preventDefault();

    const url = getCreateListUrl(this.idValue);
    await postRequest(url, { name: "" });
  }

  _registerEvents() {
    const dispatcher = Container.resolve('boardStreamListener').eventDispatcher;
    
    dispatcher.register(this.streamTagValue, "NewList", data => this._onNewListEvent(data));
  }

  _onNewListEvent(data) {
    this.listsTarget.insertAdjacentHTML('beforeend', data);
  }
}
