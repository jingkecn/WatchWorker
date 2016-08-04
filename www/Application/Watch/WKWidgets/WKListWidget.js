importScripts("WKAbstractWidget");
importScripts("WKListWidgetController");
class WKListWidget extends WKAbstractWidget {

    constructor(init) {
        super(init);
        this.controller = new WKListWidgetController(this);
    }

    get remoteView() {
        return {
            id: this.id
        }
    }

}