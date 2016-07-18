/*
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */
var app = {
    ids: {
        deviceready: "deviceready"
    },
    // Application Constructor
    initialize: function() {
        this.bindEvents();
    },
    // Bind Event Listeners
    //
    // Bind any events that are required on startup. Common events are:
    // 'load', 'deviceready', 'offline', and 'online'.
    bindEvents: function() {
        document.addEventListener('deviceready', this.onDeviceReady, false);
    },
    // deviceready Event Handler
    //
    // The scope of 'this' is the event. In order to call the 'receivedEvent'
    // function, we must explicitly call 'app.receivedEvent(...);'
    onDeviceReady: function() {
        app.receivedEvent('deviceready');
    },
    // Update DOM on a Received Event
    receivedEvent: function(id) {
        var parentElement = document.getElementById(id);
        var listeningElement = parentElement.querySelector('.listening');
        var receivedElement = parentElement.querySelector('.received');

        // if (smartwatchworker) {
        //     app.testSmartWatchWorker(smartwatchworker);
        // }

        listeningElement.setAttribute('style', 'display:none;');
        receivedElement.setAttribute('style', 'display:block;');

        console.log('Received Event: ' + id);
    },
    // Testing smartwatchworker
    testSmartWatchWorker: function (worker) {
        var onSuccess = function () {
            worker.addEventListener("message", function (message) {
                // Receiving message
                var parentElement = document.getElementById(app.ids.deviceready);
                var messageElement = parentElement.querySelector('.message');
                messageElement.setAttribute('style', 'display:block');
                messageElement.textContent = message;
            });
            worker.addEventListener("error", function (error) {
                // Receiving error
                var parentElement = document.getElementById(app.ids.deviceready);
                var errorElement = parentElement.querySelector('.error');
                errorElement.setAttribute('style', 'display:block');
                errorElement.textContent = error;
            });
            worker.postMessage("Message from web view!");
        };
        var onError = function () {};
        worker.initialize("InsideWatchWorker", onSuccess, onError);
    }
};

app.initialize();