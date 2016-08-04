importScripts("ApplicationController")
importScripts("WKApplication");

class Application {

    constructor() {
        this.controller = new ApplicationController(this);
    }

    initialize(init) {
        
    }

    static get singleton() {
        if (!this.__singleton__) {
            this.__singleton__ = new Application();
        }
        return this.__singleton__;
    }

}