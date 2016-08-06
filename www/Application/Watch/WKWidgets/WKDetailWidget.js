importScripts("WKAbstractWidget.js");
importScripts("WKDetailWidgetController.js");
class WKDetailWidget extends WKAbstractWidget {

    constructor(init) {
        super(init);
        this.controller = new WKDetailWidgetController(this);
    }

    get remoteView() {
        return {
            id: this.id
        }
    }

}