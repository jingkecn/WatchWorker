importScripts("WKAbstractWidgetController");
class WKMenuWidgetController extends WKAbstractWidgetController {

    constructor(controlled) {
        super(controlled);
    }

    onAction(index) {
        switch (index) {
            case 0:
                this.parentController.displayScreen("ListScreen", { title: "News List", wcontext: { id: "ListWidget", dataType: "News" } });
                break;
            case 1:
                this.parentController.displayScreen("ListScreen", { title: "Tweets List", wcontext: { id: "ListWidget", dataType: "Tweets" } });
                break;
            default:
                break;
        }
    }

}