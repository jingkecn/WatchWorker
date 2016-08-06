importScripts("EventTarget.js");
/**
 * Polyfill
 * The Document interface represents any web page loaded in the browser and serves as an entry point into the web page's content, which is the DOM tree. 
 * The DOM tree includes elements such as <body> and <table>, among many others. 
 * It provides functionality which is global to the document, such as obtaining the page's URL and creating new elements in the document.
 * The Document interface describes the common properties and methods for any kind of document. 
 * Depending on the document's type (e.g. HTML, XML, SVG, …), a larger API is available: HTML documents, served with the text/html content type, 
 * also implement the HTMLDocument interface, wherease SVG documents implement the SVGDocument interface.
 */
class Document extends EventTarget {

    constructor(instance) {
        super();
        if (this.constructor.name !== "Document") { return; }
        this.instance = instance || scope && scope.createEventTarget();
    }

    static create(instance) {
        return new Document(instance);
    }

}