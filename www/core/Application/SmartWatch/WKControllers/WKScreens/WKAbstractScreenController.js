importScripts("JSONRPCService");
importScripts("WKAbstractController");

class WKAbstractScreenController extends WKAbstractController {

    constructor(controlled) {
        super(controlled);
        this.observers = {};
        this.addObserver(this.onWidgetAction.bind(this));
        if (!this.onContextMenuAction) { return; }
        this.addObserver(this.onContextMenuAction.bind(this));
    }

    get widgetControllers() {
        var self = this;
        return this.controlled.widgets.map(function (widget) {
            widget.controller.initialize(self);
            return widget.controller;
        });
    }

    awakeWithContext(context) {
        this.parentController.initScreen(this.controlled.remoteView);
        if (!context) { return; }
        this.updateRemoteContext(context);
        this.updateWidgetContext(context);
    }

    willActivate() {}

    didAppear() {}

    willDisappear() {}

    didDeactivate() {}

    updateRemoteContext(context) {
        this.parentController.updateRemoteContext(context);
    }

    displayScreen(id, context) {
        this.parentController.displayScreen(id, context);
    }

    updateWidgetContext(context) {
        var wcontext = context.wcontext;
        if (!wcontext) { return; }
        this.widgetControllers.forEach(function (controller) {
            controller.updateContext(wcontext);
        });
    }

    onWidgetAction(wid, params) {
        var controller = this.widgetControllers.find(function (controller) {
            return controller.controlled.id === wid;
        });
        if (!controller) { return; }
        controller.dispatchObserver("onAction", params);
    }

}