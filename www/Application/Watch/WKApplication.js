importScripts("WKMenuScreen.js");
importScripts("WKListScreen.js");
importScripts("WKDetailScreen.js");
importScripts("WKMenuWidget.js");
importScripts("WKListWidget.js");
importScripts("WKDetailWidget.js");
importScripts("WKApplicationController.js");

class WKApplication {

    constructor() {
        this.currentScreen = this.menuScreen;
        if (this.initialized) { return; }
        this.controller = new WKApplicationController(this);
        console.info("[WKApplication.initialize]", this);
    }

    initialize() {
        
    }

    get screens() {
        return [this.menuScreen, this.listScreen, this.detailScreen];
    }

    get menuScreen() {
        if (!this.__menuScreen__) {
            var menuWidget = new WKMenuWidget({ id: "MenuWidget" });
            menuWidget.addItem({ title: "List Our News" });
            menuWidget.addItem({ title: "List Our Tweets" });
            // Page-style navigation is not yet supported
            // menuWidget.addItem({ title: "Read Our News" });
            // menuWidget.addItem({ title: "See Our Tweets" });
            var menuScreen = new WKMenuScreen({ id: "MenuScreen", title: "Menu" });
            menuScreen.addWidget(menuWidget);
            menuScreen.addContextMenu({ title: "Refresh", icon: "resume" });
            this.__menuScreen__ = menuScreen;
        }
        return this.__menuScreen__;
    }

    get listScreen() {
        if (!this.__listScreen__) {
            var listWidget = new WKListWidget({ id: "ListWidget" });
            var listScreen = new WKListScreen({ id: "ListScreen", title: "List" });
            listScreen.addWidget(listWidget);
            listScreen.addContextMenu({ title: "Refresh", icon: "resume" });
            this.__listScreen__ = listScreen;
        }
        return this.__listScreen__;
    }

    get detailScreen() {
        if (!this.__detailScreen__) {
            var detailWidget = new WKDetailWidget({ id: "DetailWidget" });
            var detailScreen = new WKDetailScreen({ id: "DetailScreen", title: "Detail" });
            detailScreen.addWidget(detailWidget);
            detailScreen.addContextMenu({ title: "Refresh", icon: "resume" });
            this.__detailScreen__ = detailScreen;
        }
        return this.__detailScreen__;
    }

    static get singleton() {
        if (!this.__singleton__) {
            this.__singleton__ = new WKApplication();
        }
        return this.__singleton__;
    }

}