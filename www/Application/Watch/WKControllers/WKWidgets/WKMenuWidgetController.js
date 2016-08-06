importScripts("NewsService.js");
importScripts("TwitterService.js");
importScripts("WKAbstractWidgetController.js");
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
            // Page-style navigation is not yet supported
            // case 2:
            //     var self = this;
            //     NewsService.singleton.fetchItems().then(function (items) {
            //         if (!items) { return; }
            //         var contexts = items.map(function (item) {
            //             var screenTitle = item.title || "Detail";
            //             var wcontext = { id: "DetailWidget", context: item };
            //             var context = { title: screenTitle, wcontext: wcontext };
            //             return context;
            //         });
            //         self.parentController.displayScreen("DetailScreen", contexts);
            //     }).catch(function (error) {
            //         console.error("Error fetching items", error);
            //     });
            //     break;
            // case 3:
            //     var self = this;
            //     TwitterService.singleton.fetchItems().then(function (items) {
            //         if (!items) { return; }
            //         var contexts = items.map(function (item) {
            //             var screenTitle = item.title || "Detail";
            //             var wcontext = { id: "DetailWidget", context: item };
            //             var context = { title: screenTitle, wcontext: wcontext };
            //             return context;
            //         });
            //         self.parentController.displayScreen("DetailScreen", contexts);
            //     }).catch(function (error) {
            //         console.error("Error fetching items", error);
            //     });
            //     break;
            default:
                break;
        }
    }



}