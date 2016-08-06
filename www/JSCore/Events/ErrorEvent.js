importScripts("Event.js");

class ErrorEvent extends Event {

    constructor(type, init, instance) {
        super(type, init);
        if (this.constructor.name !== "ErrorEvent") { return; }
        this.instance = instance || scope && scope.createErrorEvent(type, init);
    }

    get message() { return this.instance.message; }
    get filename() { return this.instance.filename; }
    get lineno() { return this.instance.lineno; }
    get colno() { return this.instance.colno; }
    get error() { return this.instance.error; }

    static create(instance) {
        return new Error(instance.type, {}, instance);
    }

}