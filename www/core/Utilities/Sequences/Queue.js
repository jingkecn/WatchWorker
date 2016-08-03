class Queue {

    constructor() {
        this.items = [];
    }

    get isEmpty() {
        return this.items.length === 0;
    }

    get frontItem() {
        return this.isEmpty ? (void 0) : this.items[0];
    }

    enqueue() {
        for(var argument of arguments) {
            this.items.push(argument);
        }
    }

    dequeue() {
        return this.isEmpty ? (void 0) : this.items.shift();
    }

}