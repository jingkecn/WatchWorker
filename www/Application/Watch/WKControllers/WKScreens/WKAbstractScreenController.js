importScripts("JSONRPCService");
importScripts("WKAbstractController");

class WKAbstractScreenController extends WKAbstractController {

    constructor(controlled) {
        super(controlled);
        this.addObserver(this.onScreenAction.bind(this));
        this.addObserver(this.onWidgetAction.bind(this));
        if (!this.onContextMenuAction) { return; }
        this.addObserver(this.onContextMenuAction.bind(this));
    }

    /**
     * controllers of all widgets
     */
    get widgetControllers() {
        var self = this;
        return this.controlled.widgets.map(function (widget) {
            widget.controller.initialize(self);
            return widget.controller;
        });
    }

    // MARK: ********** Remote controlling **********

    /**
     * This method will push or present a watch view controller specified by it's id with context.
     * if context is an array, screen controller will be presented as page style (currently buggy),
     *      otherwise screen controller will be pushed as a stack-like navigation.
     * @param   {String}            [required]    id = { MenuScreen | ListScreen | DetailScreen }
     * @param   {Array|Dictionary}  [optional]    context optional
     */
    displayScreen(id, context) {
        this.parentController.displayScreen(id, context);
    }

    /**
     * This method will initialize the current watch view controller with a controlled remote view.
     */
    initScreen() {
        this.parentController.initScreen(this.controlled.remoteView);
    }

    /**
     * This method will update native context of the current watch view controller.
     * @param   {Array|Dictionary}      [required]    context
     */
    updateRemoteContext(context) {
        this.parentController.updateRemoteContext(context);
    }

    // MARK: ********** Actions triggered by native screen **********

    /**
     * This method is called when watch view controller is awake with or without context.
     * @param   {Array|Dictionary}  [optional]  context
     */
    awakeWithContext(context) {
        // FIXME: should support page navigation!
        this.initScreen();
        if (!context) { return; }
        this.updateRemoteContext(context);
        this.updateWidgetContext(context);
    }

    /**
     * This method is called when watch view controller is about to be visible to user.
     */
    willActivate() {}

    /**
     * This method is called when watch view controller has been visible to user.
     */
    didAppear() {}

    /**
     * This method is called when watch view controller is about to be invisible to user.
     */
    willDisappear() {}

    /**
     * This method is called when watch view controller has been invisible to user.
     */
    didDeactivate() {}

    /**
     * This method is called when an action of watch view controller is triggered by user.
     * @param   {String}            [required]    action
     * @param   {Array|Dictionary}  [optional]    params
     */
    onScreenAction(action, params) {
        this.dispatchObserver(action, params);
    }

    /**
     * This method is called when an action of watch view controller's widget is triggered by user.
     * @param   {String}            [required]    wid
     * @param   {Array|Dictionary}  [optional]    params
     */
    onWidgetAction(wid, params) {
        var controller = this.widgetControllers.find(function (controller) {
            return controller.controlled.id === wid;
        });
        if (!controller) { return; }
        controller.dispatchObserver("onAction", params);
    }

    // MARK: ********** Widget handlers **********

    updateWidgetContext(context) {
        var wcontext = context.wcontext;
        if (!wcontext) { return; }
        this.widgetControllers.forEach(function (controller) {
            controller.updateContext(wcontext);
        });
    }

}