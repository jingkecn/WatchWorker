var worker1 = new SharedWatchWorker("SharedWorkerScope");
worker1.port.addEventListener("message", function (event) {
    console.log("From worker1", event.data);
});
worker1.port.start();

var worker2 = new SharedWatchWorker("SharedWorkerScope");
worker2.port.addEventListener("message", function (event) {
    console.log("From worker2", event.data);
});
worker2.port.start();

// worker1.port.postMessage("test1");
// worker2.port.postMessage("test2");