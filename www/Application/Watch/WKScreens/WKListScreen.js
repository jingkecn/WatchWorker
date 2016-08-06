importScripts("WKAbstractScreen.js");
importScripts("WKListScreenController.js");

class WKListScreen extends WKAbstractScreen {

    constructor(init) {
        super(init);
        this.controller = new WKListScreenController(this);
    }

}