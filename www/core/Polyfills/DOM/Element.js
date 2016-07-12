importScripts("EventTarget");
/**
 * Polyfill
 * The Element interface represents an object of a Document. 
 * This interface describes methods and properties common to all kinds of elements. 
 * Specific behaviors are described in interfaces which inherit from Element but add additional functionality. 
 * For example, the HTMLElement interface is the base interface for HTML elements, while the SVGElement interface is the basis for all SVG elements.
 * Languages outside the realm of the Web platform, like XUL through the XULElement interface, also implement it.
 */
class Element extends EventTarget {
    
}