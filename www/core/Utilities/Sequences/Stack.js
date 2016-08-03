class Stack {

    constructor() {
        this.items = [];
    }

    get isEmpty() {
        return this.items.length === 0;
    }

    get topItem() {
        return this.isEmpty ? (void 0) : this.items[this.items.length - 1];
    }

    push() {
        for(var argument of arguments) {
            this.items.push(argument);
        }
    }

    pop() {
        return this.isEmpty ? (void 0) : this.items.pop();
    }

}