importScripts("WKAbstractScreen.js");
importScripts("WKMenuScreenController.js")
class WKMenuScreen extends WKAbstractScreen {

    constructor(init) {
        super(init);
        this.controller = new WKMenuScreenController(this);
    }

}