import { streamId } from '../utils/stream_id';
import { StreamListener } from "./stream_listener";

class SimpleConatiner {
  constructor() {
    this.dependencies = new Map();
  }

  register(identifier, resolver) {
    this.dependencies.set(identifier, { resolver: resolver, store: null });
  }

  resolve(identifier) {
    const dependency = this.dependencies.get(identifier);

    dependency.store ??= dependency.resolver();
    return dependency.store;
  }
}

const container = new SimpleConatiner();
container.register("boardStreamListener", _ => new StreamListener(streamId));

export default container;
