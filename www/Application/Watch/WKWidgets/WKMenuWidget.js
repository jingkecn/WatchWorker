importScripts("WKAbstractWidget");
importScripts("WKMenuWidgetController");

class WKMenuWidget extends WKAbstractWidget {

    constructor(init) {
        super(init);
        this.items = [];
        this.controller = new WKMenuWidgetController(this);
    }

    get remoteView() {
        return {
            id: this.id,
            items: this.items
        }
    }

    addItem(item) {
        this.items.push(item);
    }

}