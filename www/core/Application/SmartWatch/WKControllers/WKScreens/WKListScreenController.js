importScripts("WKAbstractScreenController");
class WKListScreenController extends WKAbstractScreenController {

    constructor(controlled) {
        super(controlled);
    }

    refresh() {}

    onContextMenuAction(index) {
        switch (index) {
            case 0:
                this.refresh();
                break;
        
            default:
                break;
        }
    }

}