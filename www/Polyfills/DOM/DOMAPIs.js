importScripts("Document");
importScripts("DOMTokenList");
importScripts("Element");
importScripts("HTMLDocument");
importScripts("HTMLElement");
importScripts("Window");

this.setImmediate = Window.prototype.setImmediate;
this.setTimeout = Window.prototype.setTimeout;
this.setInterval = Window.prototype.setInterval;
this.clearImmediate = Window.prototype.clearImmediate;
this.clearTimeout = Window.prototype.clearTimeout;
this.clearInterval = Window.prototype.clearInterval;