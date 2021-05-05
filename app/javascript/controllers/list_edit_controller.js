import { Controller } from "stimulus"

export default class extends Controller {
  static values = { editMode: Boolean };
  static targets = [ "name" ];

  connect() {
    this._setupModeChange();
  }

  enterEditMode() {
    this.nameTarget.readOnly = false;
    this.editModeValue = true;

    this.nameTarget.focus();
  }

  async exitEditMode(event) {
    event.preventDefault();
    if(!this.editModeValue) return;
  
    this.nameTarget.readOnly = true;
    this.editModeValue = false;

    this.nameTarget.blur();
    await this.listController.updateName(this.nameTarget.value);
  }

  get listController() {
    return this.application.getControllerForElementAndIdentifier(this.element, "list");
  }

  async _setupModeChange() {
    this.nameTarget.addEventListener("dblclick", _ => this.enterEditMode());
    this.nameTarget.addEventListener("blur", event => this.exitEditMode(event));
  }
}
