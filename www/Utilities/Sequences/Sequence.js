class Sequence {

    constructor() {
        this.items = [];
        this.observers = {};
        this.blocked = false;
    }

    get length() {
        return this.items.length;
    }

    get isEmpty() {
        return this.items.length === 0;
    }

    get firstItem() {
        return this.items[0] || null;
    }

    get lastItem() {
        return this.items[this.length - 1] || null;
    }

    push(item) {
        this.items.push(item);
        this.dispatchObserver("push");
    }

    pop() {
        var item = this.items.pop();
        this.dispatchObserver("pop");
        return item;
    }

    shift(item) {
        this.items.shift(item);
        this.dispatchObserver("shift");
    }

    unshift() {
        var item = this.items.unshift();
        this.dispatchObserver("unshift");
        return item;
    }

    addObserver(type, observer) {
        (this.observers[type] = this.observers[type] || []).push(observer);
        return this;
    }

    removeObserver(type, observer) {
        if (!type) { this.observers = {}; }
        else if (!observer) { delete this.observers[type] }
        else {
            // TODO
        }
    }

    dispatchObserver(type) {
        var observers = this.observers[type];
        if (!observers || !Array.isArray(observers)) { return; }
        observers.forEach(function (observer) {
            observer.apply(this, [this]);
        });
    }

}