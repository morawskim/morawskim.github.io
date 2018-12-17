# angular - jawne wywołanie detektora zmian (change detection)

Do pliku `main.ts` importujemy funkcję `enableDebugTools` z `@angular/platform-browser`

```
import {enableDebugTools} from '@angular/platform-browser';
```

Następnie w tym samym pliku w miejscu, gdzie następuje rozruch aplikacji dopisujemy
```
.then((appRef: any) => enableDebugTools(appRef))
```

Czyli nasz fragment kodu powinien wyglądać mniej więcej tak:

```
platformBrowserDynamic().bootstrapModule(AppModule)
  .then((appRef: any) => enableDebugTools(appRef))
  .catch(err => console.log(err));
```

W konsoli JS przeglądarki mając wcześniej zaznaczony nasz element DOM możemy zmodyfikować dane komponentu i wywołać detektora zmian. Widok zostanie zaktualizowany.
```
ng.probe($0)._debugContext.component.post.title = "aaaaaaa"
ng.profiler.appRef.tick()
```