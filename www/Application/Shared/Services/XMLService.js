importScripts("WebService.js");

class XMLService extends WebService {

    constructor(url) {
        super(url);
    }

    fetchItems() {
        console.debug(`[${this.constructor.name}.fetchItems] uri = ${this.url}`);
        var self = this;
        return this.fetch(self.url).then(function (xmlStr) {
            return self.parseItems(xmlStr);
        }).catch(function (error) {
            console.error(`Error gettting xml from ${self.url}`, error);
        });
    }

    parseItems(str) {
        str = this.entityToString(str);
        var itemStrs = this.getContents(str, "<item>", "</item>");
        if (!itemStrs) { return; }
        var self = this;
        var items = itemStrs.map(function (itemStr) {
            return {
                title: self.getContent(itemStr, "<title>", "</title>") || null,
                description: self.getContent(itemStr, "<description>", "</description>").replace("<![CDATA[", "").replace("]]>", "") || null,
                link: self.getContent(itemStr, "<link>", "</link>") || null,
            }
        });
        return items;
    }

}