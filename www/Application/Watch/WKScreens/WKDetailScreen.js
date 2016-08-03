importScripts("WKAbstractScreen");
importScripts("WKDetailScreenController");

class WKDetailScreen extends WKAbstractScreen {

    constructor(init) {
        super(init);
        this.controller = new WKDetailScreenController(this);
    }

}