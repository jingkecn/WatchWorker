importScripts("WebService");

class ImageService extends WebService {

    requestImageUrl(link) {
        var self = this;
        return self.fetch(link).then(function (htmlString) {
            var imageTagString = self.getContent(htmlString, `<span class="post-featured-img">`, `</span>`);
            if (!imageTagString) { return null; }
            return self.getContent(imageTagString,  `src="`, `" class="`);
        }).catch(function (error) {
            console.error(`Error gettting html from ${link}`, error);
        });
    }

    static get singleton() {
        if (!this.__singleton__) {
            this.__singleton__ = new ImageService();
        }
        return this.__singleton__;
    }

}