importScripts("XMLService.js");

class NewsService extends XMLService {

    constructor() {
        super("http://www.wiztivi.com/feed");
    }

    static get singleton() {
        if (!this.__singleton__) {
            this.__singleton__ = new NewsService();
        }
        return this.__singleton__;
    }

}