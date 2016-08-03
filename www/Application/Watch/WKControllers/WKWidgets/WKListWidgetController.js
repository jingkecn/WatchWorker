importScripts("NewsService");
importScripts("TwitterService");
importScripts("WKAbstractWidgetController");

class WKListWidgetController extends WKAbstractWidgetController {

    constructor(controlled) {
        super(controlled);
        this.items = null;
    }

    updateContext(context) {
        var wid = context.id;
        if (wid !== this.controlled.id) { return; }
        switch (context.dataType) {
            case "News":
                this.updateNewsContext();
                break;
            case "Tweets":
                this.updateTweetsContext();
                break;
            default:
                break;
        }
    }

    updateNewsContext() {
        var self = this;
        NewsService.singleton.fetchItems().then(function (items) {
            if (!items) { return; }
            self.items = items;
            self.updateRemoteContext(items);
        }).catch(function (error) {
            console.error("Error fetching items", error);
        });
    }

    updateTweetsContext() {
        var self = this;
        TwitterService.singleton.fetchItems().then(function (items) {
            if (!items) { return; }
            self.items = items;
            self.updateRemoteContext(items);
        }).catch(function (error) {
            console.error("Error fetching items", error);
        });
    }

    onAction(index) {
        if (!this.items) { return; }
        var item = this.items[index];
        if (!item) { return; }
        this.parentController.displayScreen("DetailScreen", { title: item.title || "Detail", wcontext: { id: "DetailWidget", context: item } });
    }

}