importScripts("WKAbstractScreen");
importScripts("WKListScreenController");

class WKListScreen extends WKAbstractScreen {

    constructor(init) {
        super(init);
        this.controller = new WKListScreenController(this);
    }

}