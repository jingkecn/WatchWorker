importScripts("JSONRPCService");
importScripts("Sequence");
importScripts("SharedWatchWorker");
importScripts("WKAbstractController");
importScripts("WKMenuScreenController");
importScripts("WKListScreenController");

class WKApplicationController extends WKAbstractController {

    constructor(controlled) {
        super(controlled);
        this.scope = new SharedWatchWorker("WKApplicationScope");
        this.scope.port.start();
        this.service = new JSONRPCService(this.scope.port);
        this.service.registerScope(this);
    }

    get screenControllers() {
        var self = this;
        return this.controlled.screens.map(function (screen) {
            screen.controller.initialize(self);
            return screen.controller;
        });
    }

    get currentScreenController() {
        return this.controlled.currentScreen.controller;
    }
    set currentScreenController(controller) {
        this.controlled.currentScreen = controller.controlled;
    }

    displayScreen(id, context) {
        context = context || null;
        this.service.sendRequest("displayScreen", { id: id, context: context });
    }

    initScreen(remoteView) {
        if (!remoteView) { return; }
        this.service.sendRequest("initScreen", remoteView).then(function (result) {
            console.info("Response from Apple Watch", result);
        }).catch(function (error) {
            console.info("Error from Apple Watch", error);
        });
    }

    updateRemoteContext(context) {
        if (!context) { return; }
        this.service.sendRequest("updateContext", context).then(function (result) {
            console.info("Response from Apple Watch", result);
        }).catch(function (error) {
            console.info("Error from Apple Watch", error);
        });
    }

    /**
     * On screen launch
     */
    awakeWithContext(id, context) {
        context = context || null;
        console.debug("Screen awake with context", id, context);
        var controller = this.screenControllers.find(function (controller) {
            return controller.controlled.id === id;
        });
        if (!controller) { return; }
        this.currentScreenController = controller;
        this.currentScreenController.awakeWithContext(context);
    }

    /**
     * On screen before show
     */
    willActivate(id) {
        console.debug("Screen will activate", id);
        var controller = this.screenControllers.find(function (controller) {
            return controller.controlled.id === id;
        });
        if (!controller) { return; }
        this.currentScreenController = controller;
        this.currentScreenController.willActivate();
    }

    /**
     * On screen after show
     */
    didAppear(id) {
        console.debug("Screen did appear", id);
        var controller = this.screenControllers.find(function (controller) {
            return controller.controlled.id === id;
        });
        if (!controller) { return; }
        this.currentScreenController = controller;
        this.currentScreenController.didAppear();
    }

    /**
     * On screen before hide
     */
    willDisappear(id) {
        console.debug("Screen will disappear", id);
    }

    /**
     * On screen after hide
     */
    didDeactivate(id) {
        console.debug("Screen did deactivate", id);
        
    }

    /**
     * Screen action
     */
    onScreenAction(method, params) {
        console.debug("On screen action", method, params);
        this.currentScreenController.dispatchObserver(method, params);
    }

}