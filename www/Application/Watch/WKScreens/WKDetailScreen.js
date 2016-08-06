importScripts("WKAbstractScreen.js");
importScripts("WKDetailScreenController.js");

class WKDetailScreen extends WKAbstractScreen {

    constructor(init) {
        super(init);
        this.controller = new WKDetailScreenController(this);
    }

}