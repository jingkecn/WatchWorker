importScripts("XMLService");

class TwitterService extends XMLService {

    constructor() {
        super("http://twitrss.me/twitter_user_to_rss/?user=Wiztivi_France");
    }

    fetchItems() {
        return super.fetchItems().then(function (items) {
            return items && items.map(function (item) {
                return {
                    title: "Wiztivi France",
                    description: item.title
                };
            });
        });
    }

    static get singleton() {
        if (!this.__singleton__) {
            this.__singleton__ = new TwitterService();
        }
        return this.__singleton__;
    }

}