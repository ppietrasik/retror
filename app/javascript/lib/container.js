import { createContainer, asClass, InjectionMode } from 'awilix'
import { streamId } from '../utils/stream_id';
import { StreamListener } from "./stream_listener";

const container = createContainer({ injectionMode: InjectionMode.CLASSIC });

container.register({
  boardStreamListener: asClass(StreamListener).inject(() => ({ streamId: streamId })).singleton()
})

export default container;
