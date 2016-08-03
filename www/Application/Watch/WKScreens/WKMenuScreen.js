importScripts("WKAbstractScreen");
importScripts("WKMenuScreenController")
class WKMenuScreen extends WKAbstractScreen {

    constructor(init) {
        super(init);
        this.controller = new WKMenuScreenController(this);
    }

}