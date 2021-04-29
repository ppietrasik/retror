export class EventDispatcher {
  constructor() {
    this.listeners = new NestedSet();
  }

  register(identifier, event, fn) {
    this.listeners.add(fn, identifier, event);
  }

  unregister(identifier, event, fn) {
    this.listeners.get(identifier, event)?.delete(fn);
  }

  unregisterEvent(identifier, event) {
    this.listeners.get(identifier, event)?.clear();
  }

  unregisterIdentifier(identifier) {
    this.listeners.get(identifier)?.clear();
  }

  dispatch(identifier, event, data) {
    this.listeners.get(identifier, event)?.forEach(fn => fn(data));
  }

  clean() {
    this.listeners = new NestedSet();
  }
}

class NestedSet {
  constructor() {
    this.root = new Map();
  }
  
  add(fn, ...keys) {
    let map = this.root;
    
    for (const key of keys.slice(0, -1)) {
      map.has(key) || map.set(key, new Map());
      map = map.get(key);
    }

    const key = keys[keys.length-1];
    map.has(key) || map.set(key, new Set());
	
    const set = map.get(key);
    set.add(fn);
  }
  
  get(...keys) {
    let map = this.root;

    for (const key of keys) {
      map = map?.get(key);
    }

    return map;
  }
}
