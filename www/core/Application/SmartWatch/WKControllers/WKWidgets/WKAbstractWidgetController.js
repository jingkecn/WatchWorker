importScripts("WKAbstractController");

class WKAbstractWidgetController extends WKAbstractController {

    constructor(controlled) {
        super(controlled);
        if (!this.onAction) { return; }
        this.addObserver(this.onAction.bind(this));
    }

    updateContext(context) {
        // TODO: Update local context
    }

    updateRemoteContext(context) {
        this.parentController.updateRemoteContext(context);
    }

    // onAction(params) {}

}