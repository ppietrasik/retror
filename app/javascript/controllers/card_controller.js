import autosize from 'autosize'
import { Controller } from "stimulus"

export default class extends Controller {
  static values = { id: String, streamTag: String };
  static targets = [ "note" ];

  connect() {
    autosize(this.noteTarget);
  }
}
