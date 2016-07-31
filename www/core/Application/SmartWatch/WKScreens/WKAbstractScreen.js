importScripts("WKAbstractScreenController");
class WKAbstractScreen {

    constructor(init) {
        this.id = init && init.id || null;
        this.title = init && init.title || null;
        this.widgets = [];
        this.contextMenuItems = [];
    }

    get remoteView() {
        return {
            id: this.id,
            title: this.title,
            widgets: this.widgets.map(function (widget) { return widget.remoteView }),
            contextMenu: this.contextMenuItems
        };
    }

    // get stringValue() { return JSON.stringify(this); }

    addWidget(widget) {
        // this.controller.addWidgetController(widget.controller);
        this.widgets.push(widget);
    }

    addContextMenu(item) {
        this.contextMenuItems.push(item);
    }

}