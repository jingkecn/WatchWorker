importScripts("WKAbstractController.js");

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
        this.parentController.updateRemoteContext({ wcontext: { id: this.controlled.id, context: context } });
    }

    // onAction(params) {}

}