import { getCableConsumer } from "../utils/cable";

export class ChannelSubscriber {
  constructor(channel, params) {
    const { subscriptions } = getCableConsumer();
    this.subscription = subscriptions.create(channel, params);
  }

  unsubscribe() {
    this.subscription.unsubscribe();
  }
}
