Angular promise - pobierz wszystkie dane
========================================

Kiedy musimy pobrać dużo danych np. aby wygenerować mapkę serwerów musimy pobierać je w paczkach. Przydaje się tu usługa $q biblioteki angular'a. Musimy utworzyć usługę.

``` javascript
app.factory("DownloadAllService", ["$http", "$q", function($http, $q){
        return {
            'echoRequest': function() {
                var attempt = 0;
                var deferred = $q.defer();
                function sendEchoRequest() {
                    console.log("SEND AJAX REQUEST...");
                    $http.get("/echo/json")
                    .success(function(response) {
                        attempt += 1;
                        if (attempt < 3) {
                            sendEchoRequest();
                        } else {
                            deferred.resolve({run: attempt});
                        }
                    }).error(function(response) {
                        deferred.reject("AJAX ERROR", response);
                    });
                }

                sendEchoRequest();
                return deferred.promise;
            }
        };
    }]);
```

Potrzebny jest też kontroler, który wywoła metodę naszej usługi.

``` javascript
app.controller("PromiseCtrl", ["$scope", "DownloadAllService",  function($scope, DownloadAllService) {
        function successCallback(attempts) {
            alert("SUCCESS - ALL DATA DOWNLOAD. ATTEMPTS: " + attempts.run);
        }

        function errorCallback(msg, response) {
            alert("ERROR: " + msg);
        }

        $scope.initPromise = function() {

        };

        $scope.downloadAllData = function() {
          DownloadAllService.echoRequest().then(successCallback, errorCallback);
        };
    }]);
```

Potrzebujemy też linku. Po kliknięciu w niego zaczną pobierać się dane. Dopiero po pobraniu wszystkich danych zostanie wywołana funkcja zwrotna. W przypadku, gdy jakieś wywołanie ajax się nie powiedzie dalsze pobieranie danych zostanie zatrzymane i wywołana zostanie inna funkcja zwrotna.

```
  <div class="well" ng-app="promiseApp" ng-controller="PromiseCtrl" ng-init="initPromise();">
        Test promise - download all data
        <a href="#" ng-click="downloadAllData();">KLIK</a>
</div>
```

Live demo dostępne pod adresem [1](http://jsfiddle.net/zgc0khcc/3/)