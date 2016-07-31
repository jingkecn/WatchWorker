importScripts("WKAbstractWidgetController");
class WKDetailWidgetController extends WKAbstractWidgetController {

    constructor(controlled) {
        super(controlled);
    }

    updateContext(context) {
        var wid = context.id;
        if (!wid !== this.controlled.id) { return; }
        this.updateRemoteContext(context);
    }

}