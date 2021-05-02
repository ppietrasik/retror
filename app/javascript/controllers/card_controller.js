import autosize from 'autosize'
import { deleteRequest, patchRequest } from "../utils/api_requests"
import { getCardUrl } from "../utils/api_urls";
import Container from "../lib/container"
import { Controller } from "stimulus"

export default class extends Controller {
  static values = { id: String, streamTag: String };
  static targets = [ "note" ];

  connect() {
    autosize(this.noteTarget);
    this._registerEvents();
  }

  disconnect() {
    const dispatcher = Container.resolve("boardStreamListener").eventDispatcher;
    dispatcher.unregisterIdentifier(this.streamTagValue);
  }
  
  async delete() {
    const url = getCardUrl(this.idValue);
    await deleteRequest(url);
  }

  _registerEvents() {
    const dispatcher = Container.resolve("boardStreamListener").eventDispatcher;

    dispatcher.register(this.streamTagValue, "DeleteCard", _ => this._onDeleteCardEvent());
  }

  _onDeleteCardEvent() {
    this.element.remove();
  }
}
