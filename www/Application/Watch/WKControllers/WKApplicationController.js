importScripts("JSONRPCService.js");
importScripts("Sequence.js");
importScripts("SharedWatchWorker.js");
importScripts("WKAbstractController.js");
importScripts("WKMenuScreenController.js");
importScripts("WKListScreenController.js");

/**
 * WatchKit Application controller
 */
class WKApplicationController extends WKAbstractController {

    constructor(controlled) {
        super(controlled);
        this.scope = new SharedWatchWorker("WKApplicationScope.js");
        this.scope.port.start();
        this.service = new JSONRPCService(this.scope.port);
        this.service.registerScope(this);
    }

    /**
     * controllers of all screens
     */
    get screenControllers() {
        var self = this;
        return this.controlled.screens.map(function (screen) {
            screen.controller.initialize(self);
            return screen.controller;
        });
    }

    // MARK: ********** Remote controlling **********

    /**
     * This method will push or present a watch view controller specified by it's id with context.
     * if context is an array, screen controller will be presented as page style (currently buggy),
     *      otherwise screen controller will be pushed as a stack-like navigation.
     * @param   {String}    [required]    id = { MenuScreen | ListScreen | DetailScreen }
     * @param   {Array|Dictionary}       [optional]    context optional
     */
    displayScreen(id, context) {
        context = context || null;
        this.service.sendRequest("displayScreen", { id: id, context: context });
    }

    /**
     * This method will initialize the current watch view controller with an initial object.
     * @param   {Dictionary}    [required]    remoteView
     */
    initScreen(remoteView) {
        if (!remoteView) { return; }
        this.service.sendRequest("initScreen", remoteView).then(function (result) {
            console.info("Response from Apple Watch", result);
        }).catch(function (error) {
            console.info("Error from Apple Watch", error);
        });
    }

    /**
     * This method will update native context of the current watch view controller.
     * @param   {Array|Dictionary}      [required]    context
     */
    updateRemoteContext(context) {
        if (!context) { return; }
        this.service.sendRequest("updateContext", context).then(function (result) {
            console.info("Response from Apple Watch", result);
        }).catch(function (error) {
            console.info("Error from Apple Watch", error);
        });
    }

    // MARK: ********** Actions trigger by native screens **********

    /**
     * This method is called when watch view controller is awake with or without context.
     * @param   {Array|Dictionary}  [optional]  context
     */
    awakeWithContext(id, context) {
        context = context || null;
        console.debug("Screen awake with context", id, context);
        var controller = this.screenControllers.find(function (controller) {
            return controller.controlled.id === id;
        });
        if (!controller) { return; }
        controller.awakeWithContext(context);
    }

    /**
     * This method is called when watch view controller is about to be visible to user.
     */
    willActivate(id) {
        console.debug("Screen will activate", id);
        var controller = this.screenControllers.find(function (controller) {
            return controller.controlled.id === id;
        });
        if (!controller) { return; }
       controller.willActivate();
    }

    /**
     * This method is called when watch view controller has been visible to user.
     */
    didAppear(id) {
        console.debug("Screen did appear", id);
        var controller = this.screenControllers.find(function (controller) {
            return controller.controlled.id === id;
        });
        if (!controller) { return; }
        controller.didAppear();
    }

    /**
     * This method is called when watch view controller is about to be invisible to user.
     */
    willDisappear(id) {
        console.debug("Screen will disappear", id);
        var controller = this.screenControllers.find(function (controller) {
            return controller.controlled.id === id;
        });
        if (!controller) { return; }
        controller.willDisappear();
    }

    /**
     * This method is called when watch view controller has been invisible to user.
     */
    didDeactivate(id) {
        console.debug("Screen did deactivate", id);
        var controller = this.screenControllers.find(function (controller) {
            return controller.controlled.id === id;
        });
        if (!controller) { return; }
        controller.didDeactivate();
    }

    /**
     * This method is called when an action of watch view controller is triggered by user.
     * @param   {String}            [required]    id
     * @param   {Array|Dictionary}  [optional]    params
     */
    onScreenAction(id, params) {
        console.debug("On screen action", id, params);
        var controller = this.screenControllers.find(function (controller) {
            return controller.controlled.id === id;
        });
        if (!controller) { return; }
        controller.dispatchObserver("onScreenAction", params);
    }

}