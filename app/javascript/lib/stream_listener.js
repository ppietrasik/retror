import { ChannelSubscriber } from "./channel_subscriber";
import { EventDispatcher } from "./event_dispatcher"

export class StreamListener {
  constructor(streamId) {
    this.streamId = streamId;
    this.dispatcher = new EventDispatcher();

    this._connect();
  }

  disconnect() {
    this.channelSubscriber?.unsubscribe();
    this.eventDispatcher.clear();
  }
  
  get eventDispatcher() {
    return this.dispatcher;
  }

  _connect() {
    this.channelSubscriber = new ChannelSubscriber({ channel: 'StreamChannel', stream_id: this.streamId }, {
      received: data => this._processStream(data)
    });
  }

  _processStream({ tag, event, data }) {
    this.dispatcher.dispatch(tag, event, data);
  }
}
