import { Controller } from "stimulus"
import { patchRequest } from "../utils/api_requests"
import { getUpdateListUrl } from "../utils/api_urls";
import Container from '../lib/container'

const SUBMIT_EVENT_TYPE = "submit";

export default class extends Controller {
  static values = { id: String, streamTag: String };
  static targets = [ "name" ];

  connect() {
    this._registerEvents();
  }

  async updateName(event) {
    if(event.type === SUBMIT_EVENT_TYPE) {
      this.nameTarget.blur();
      return;
    }

    const url = getUpdateListUrl(this.idValue);
    await patchRequest(url, { name: this.nameValue });
  }

  get nameValue() {
    return this.nameTarget.value;
  }

  set nameValue(name) {
    this.nameTarget.value = name;
  }

  _registerEvents() {
    const dispatcher = Container.resolve('boardStreamListener').eventDispatcher;
    dispatcher.register(this.streamTagValue, "UpdateList", data => this._onUpdateListEvent(data));
  }

  _onUpdateListEvent({ name }) {
    this.nameValue = name;
  }
}
