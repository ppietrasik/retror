import { createConsumer } from "@rails/actioncable"

let consumer

export const getCableConsumer = _ => consumer || setupCableConsumer(); 

const setupCableConsumer = _ => consumer = createConsumer();
