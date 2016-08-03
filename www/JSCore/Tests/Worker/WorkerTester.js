var worker = new Worker("WorkerScope");
worker.addEventListener("message", function (event) {
    console.log("From inside scope", event.data);
});
worker.postMessage("testWorker");