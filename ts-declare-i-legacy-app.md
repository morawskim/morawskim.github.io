# TypeScript declare i zastana aplikacja

W aplikacjach, gdzie nie przeszło się w pełni na `typescript` mogą istnieć zmienne globalne np. `MyApp`.
Chcąc ją użyć w typescript otrzymamy błąd - `TS2339: Property 'MyApp' does not exist on type 'Window & typeof globalThis'`.

Musimy utworzyć plik z deklaracją takiej globalnej zmiennej. Tworzymy plik `app.d.ts` (nazwa jest dowolna, wymagane jest tylko rozszerzenie `.d.ts`).
W nim deklarujemy interfejs:

```
interface MyApp {
    foo: () => void,
}
```
A następnie deklarujemy zmienną globalną `MyApp` typu `MyApp` - `declare var MyApp: MyApp;`
Dzięki temu typescript nie będzie zgłaszał błędu, a IDE będzie podpowiadać nam dostępne metody/zmienne.


## pluginy jQuery

Jeśli korzystamy z pluginów jQuery, to raczej nie znajdziemy gotowego pliku deklaracji.
W takim przypadku musimy sami go stworzyć. Wystarczy tylko rozszerzyć interfejs `JQuery`/`JQueryStatic`:

```
interface JQuery {
   foo: <any|InterfejsDlaPluginuFoo>;
}
```
