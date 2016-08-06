importScripts("Document.js");
importScripts("DOMTokenList.js");
importScripts("Element.js");
importScripts("HTMLDocument.js");
importScripts("HTMLElement.js");
importScripts("Window.js");

this.setImmediate = Window.prototype.setImmediate;
this.setTimeout = Window.prototype.setTimeout;
this.setInterval = Window.prototype.setInterval;
this.clearImmediate = Window.prototype.clearImmediate;
this.clearTimeout = Window.prototype.clearTimeout;
this.clearInterval = Window.prototype.clearInterval;