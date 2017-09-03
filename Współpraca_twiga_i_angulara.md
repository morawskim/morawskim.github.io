Współpraca twiga i angulara
===========================

Angular i twig domyślnie korzystają z podwójnych nawiasów klamrowych. Angular do oznaczenia wyrażenia w interpolowanym ciągu, twig zaś do wyświetlania danych. Możemy zmodyfikować znaczniki angulara modyfikując usługę "interpolate". W tym przypadku zmieniamy symbole na nawiasy kwadratowe.

``` javascript
angular.module('myApp', []).config(function($interpolateProvider){
    $interpolateProvider.startSymbol('[[/').endSymbol('|').endSymbol(']]');
});
```

[Opis $interpolateProvider](https://docs.angularjs.org/api/ng/provider/$interpolateProvider)