import { Controller } from "stimulus"
import { postRequest } from "../utils/api_requests"
import { getCreateListUrl } from "../utils/api_urls"

export default class extends Controller {
  static values = { id: String };

  async createList(event) {
    event.preventDefault();

    const url = getCreateListUrl(this.idValue);
    await postRequest(url, { name: "" });
  }
}
