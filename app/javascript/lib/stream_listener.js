import { ChannelSubscriber } from "./channel_subscriber";
import { EventDispatcher } from "./event_dispatcher"

export class StreamListener {
  constructor(streamChannelName) {
    this.channelName = streamChannelName;
    this.dispatcher = new EventDispatcher();
  }

  connect(id) {
    this.channelSubscriber = new ChannelSubscriber({ channel: this.channelName, id }, {
      received: data => this._processStream(data)
    });
  }

  _processStream({ id, event, data }) {
    this.dispatcher.dispatch(id, event, data);
  }

  disconnect() {
    this.channelSubscriber?.unsubscribe();
    this.eventDispatcher.clear();
  }
  
  get eventDispatcher() {
    return this.dispatcher;
  }
}
