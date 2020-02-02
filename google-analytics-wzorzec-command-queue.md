# Google Analytics - wzorzec command queue

Integrując stronę WWW z usługa Google Analytics musimy na naszej stronie umieścić fragment kodu JavaScript.
Kod ten definiuje globalną funkcję `ga`. Funkcja ta nazywana jest `command queue`, ponieważ kolejkuje wywołania, zamiast natychmiast je wykonywać.
Po zmianie nazw parametrów na bardziej opisowe nasza funkcja będzie wyglądać tak:

``` javascript
(function (window, document, tagName, url, functionName, newElement, firstElement) {
window['GoogleAnalyticsObject'] = functionName;
window[functionName] = window[functionName] || function () {
(window[functionName].q = window[functionName].q || []).push(arguments)
}, window[functionName].l = 1 * new Date();
newElement = document.createElement(tagName),
firstElement = document.getElementsByTagName(tagName)[0];
newElement.async = 1;
newElement.src = url;
firstElement.parentNode.insertBefore(newElement, firstElement)
})(window, document, 'script', 'https://www.google-analytics.com/analytics.js', 'ga');

ga('create', 'UA-XXXXX-Y', 'auto');
ga('send', 'pageview');
```

Możemy korzystać z tego wzorca w podobnych scenariuszach, gdzie docelowa funkcja nie jest jeszcze załadowana, a my chcemy już z niej korzystać. Prócz statystyk, może to być także obsługa błędów.
Za pomocą `console.log.apply(this, ga.q)` wyświetlimy w konsoli kolejkę wywołań funkcji `ga` z parametrami, które zostały opakowane w obiekt `Arguments`.


https://developers.google.com/analytics/devguides/collection/analyticsjs/#the_javascript_tracking_snippet
https://developers.google.com/analytics/devguides/collection/analyticsjs/how-analyticsjs-works
https://stackoverflow.com/questions/6963779/whats-the-name-of-google-analytics-async-design-pattern-and-where-is-it-used
