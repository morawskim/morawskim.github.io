# Uncaught ReferenceError: regeneratorRuntime is not defined

Korzystając z funkcji async/await, otrzymywałem błąd w konsoli `Uncaught ReferenceError: regeneratorRuntime is not defined`. Ze względu na obsługę starych przeglądarek funkcjonalność async/await była obsługiwana przez polyfill. W zależności od wykorzystywanej wersji pakietu `Babel` mamy różne metody rozwiązania tego problemu.

Korzystając z Encore do budowania konfiguracji webpacka, ustawiamy konfigurację babel:

```
.configureBabel(() => {}, {
    useBuiltIns: 'usage',
    corejs: 3,
})
```

[Babel 7 - ReferenceError: regeneratorRuntime is not defined](https://stackoverflow.com/questions/53558916/babel-7-referenceerror-regeneratorruntime-is-not-defined/61517521#61517521)

[Regenerator Runtime is not defined](https://risanb.com/code/regenerator-runtime-is-not-defined/)
