importScripts("ImageService");
importScripts("WKAbstractWidgetController");
class WKDetailWidgetController extends WKAbstractWidgetController {

    constructor(controlled) {
        super(controlled);
    }

    updateContext(context) {
        console.log("Context for DetailWidget", context);
        var wid = context.id;
        if (!wid !== this.controlled.id) { return; }
        this.updateRemoteContext(context);
        var link = context.context.link;
        console.info("Enterring link", link);
        if (!link) { return }
        var self = this;
        ImageService.singleton.requestImageUrl(link).then(function (url) {
            console.info("fetching image from", url);
            context.context.image = { url: url };
            self.updateRemoteContext(context);
        }).catch(function (error) {
            console.error("Error fetching image", error);
        });
    }

}